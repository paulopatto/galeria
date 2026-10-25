require 'spec_helper'

RSpec.describe 'Integração HTTP com OpenTelemetry', type: :request do
  it 'registra a requisição real no coletor em memória' do
    get '/'

    span = TEST_TRACE_EXPORTER.finished_spans.find do |candidate|
      candidate.attributes['component'] == 'http'
    end
    expect(last_response.status).to eq(200)
    expect(span).not_to be_nil
    expect(span.kind).to eq(:server)
    expect(span.attributes).to include(
      'http.method' => 'GET', 'http.route' => '/', 'http.status_code' => 200
    )
  end

  it 'propaga o traceparent recebido pela pilha HTTP' do
    if RUBY_VERSION == '2.6.2' && Gem.loaded_specs['opentelemetry-common'].version.to_s == '0.19.7'
      pending 'OpenTelemetry common 0.19.7 mutates frozen header strings on Ruby 2.6.2'
    end
    trace_id = '0123456789abcdef0123456789abcdef'
    get '/', {}, 'HTTP_TRACEPARENT' => "00-#{trace_id}-0123456789abcdef-01"

    spans = TEST_TRACE_EXPORTER.finished_spans
    expect(spans).not_to be_empty
    expect(spans.map { |span| span.trace_id.unpack1('H*') }.uniq).to eq([trace_id])
  end

  it 'registra o status de uma foto inexistente' do
    get '/photo/999'

    expect(last_response.status).to eq(404)
    expect(TEST_TRACE_EXPORTER.finished_spans).to include(
      have_attributes(attributes: include('http.status_code' => 404))
    )
  end

  [200, 400].each do |status|
    it "exporta spans reais para um coletor HTTP simulado que responde #{status}" do
      collector = FakeOtlpCollector.new(status: status).start
      get '/'
      expect(last_response.status).to eq(200)
      spans = TEST_TRACE_EXPORTER.finished_spans
      expect(spans).not_to be_empty

      exporter = OpenTelemetry::Exporter::OTLP::Exporter.new(endpoint: collector.endpoint)
      result = exporter.export(spans)
      expected_result = status == 200 ? OpenTelemetry::SDK::Trace::Export::SUCCESS : OpenTelemetry::SDK::Trace::Export::FAILURE
      expect(result).to eq(expected_result)

      request = collector.request
      expect(request[:method]).to eq('POST')
      expect(request[:content_type]).to eq('application/x-protobuf')
      payload = Opentelemetry::Proto::Collector::Trace::V1::ExportTraceServiceRequest.decode(request[:body])
      exported_spans = payload.resource_spans.flat_map do |resource|
        resource.scope_spans.flat_map { |scope| scope.spans.to_a }
      end
      expect(exported_spans.map(&:trace_id)).to match_array(spans.map(&:trace_id))
      expect(exported_spans.map(&:name)).to match_array(spans.map(&:name))
    ensure
      exporter.shutdown if exporter
      collector.stop if collector
    end
  end
end
