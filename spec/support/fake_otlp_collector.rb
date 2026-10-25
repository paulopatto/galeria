require 'webrick'
require 'timeout'
require 'zlib'

# A third-party collector replacement, bound to a random loopback port.
# This exercises the real HTTP transport and protobuf serialization.
class FakeOtlpCollector
  class InvalidRequest < StandardError; end

  attr_reader :endpoint

  def initialize(status: 200)
    @requests = Queue.new
    @started = Queue.new
    @server = WEBrick::HTTPServer.new(
      BindAddress: '127.0.0.1', Port: 0, RequestTimeout: 2,
      StartCallback: -> { @started << true },
      Logger: WEBrick::Log.new(File::NULL), AccessLog: []
    )
    @server.mount_proc('/v1/traces') do |request, response|
      begin
        body = request.body.to_s
        body = Zlib.gunzip(body) if request['content-encoding'] == 'gzip'
        @requests << { method: request.request_method, content_type: request['content-type'], body: body }
        response.status = status
        response['Content-Type'] = 'application/x-protobuf'
        response.body = ''
      rescue Zlib::Error => error
        failure = InvalidRequest.new("Invalid gzip payload at #{@endpoint}: #{error.message}")
        @requests << failure
        response.status = 400
        response['Content-Type'] = 'text/plain'
        response.body = failure.message
      end
    end
    @endpoint = "http://127.0.0.1:#{@server.config[:Port]}/v1/traces"
  end

  def start
    @thread = Thread.new { @server.start }
    Timeout.timeout(5, Timeout::Error, "Fake OTLP collector did not start at #{@endpoint}") { @started.pop }
    self
  rescue StandardError
    stop
    raise
  end

  def request
    result = Timeout.timeout(5, Timeout::Error, "Fake OTLP collector received no request at #{@endpoint}") { @requests.pop }
    raise result if result.is_a?(InvalidRequest)
    result
  end

  def stop
    @server.shutdown
    if @thread && !@thread.join(5)
      raise Timeout::Error, "Fake OTLP collector did not stop at #{@endpoint}"
    end
  end
end
