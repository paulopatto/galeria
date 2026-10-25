require 'webrick'
require 'timeout'
require 'zlib'

# A third-party collector replacement, bound to a random loopback port.
# This exercises the real HTTP transport and protobuf serialization.
class FakeOtlpCollector
  attr_reader :endpoint

  def initialize(status: 200)
    @requests = Queue.new
    @server = WEBrick::HTTPServer.new(
      BindAddress: '127.0.0.1', Port: 0,
      Logger: WEBrick::Log.new(File::NULL), AccessLog: []
    )
    @server.mount_proc('/v1/traces') do |request, response|
      @requests << {
        method: request.request_method,
        content_type: request['content-type'],
        body: request['content-encoding'] == 'gzip' ? Zlib.gunzip(request.body) : request.body
      }
      response.status = status
      response['Content-Type'] = 'application/x-protobuf'
      response.body = ''
    end
    @endpoint = "http://127.0.0.1:#{@server.config[:Port]}/v1/traces"
  end

  def start
    @thread = Thread.new { @server.start }
    Timeout.timeout(5) { Thread.pass until @server.status == :Running }
    self
  rescue StandardError
    stop
    raise
  end

  def request
    Timeout.timeout(5) { @requests.pop }
  end

  def stop
    @server.shutdown
    @thread.kill if @thread && !@thread.join(5)
  end
end
