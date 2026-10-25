# Configure the environment before loading Sinatra, dotenv or OpenTelemetry.
ENV['RACK_ENV'] = 'test'
ENV['OTEL_TRACES_EXPORTER'] = 'none'

require 'bundler/setup'
require 'rspec'
require 'rack/test'
require 'yaml'
require 'opentelemetry/sdk'
require_relative 'support/fake_otlp_collector'

# The real middleware and SDK write to a local replacement for the collector.
TEST_TRACE_EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new

module RequestHelpers
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def image_urls
    last_response.body.scan(/<img src="([^"]+)" alt="([^"]+)"/).map { |url, title| [title, url] }.to_h
  end

  def photo_links
    last_response.body.scan(/<a href="(\/photo\/\d+)"/).flatten
  end
end

RSpec.configure do |config|
  original_provider = nil
  suite_provider = nil

  config.before(:suite) do
    # Load and configure the application's SDK only when the suite starts.
    original_provider = OpenTelemetry.tracer_provider
    require File.expand_path('../app', __dir__)
    suite_provider = OpenTelemetry.tracer_provider
    suite_provider.add_span_processor(
      OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(TEST_TRACE_EXPORTER)
    )
  end
  config.after(:suite) do
    begin
      suite_provider.shutdown(timeout: 5) if suite_provider && !suite_provider.equal?(original_provider)
    ensure
      OpenTelemetry.tracer_provider = original_provider if original_provider
    end
  end
  config.include RequestHelpers
  config.before do
    # Route closures hold the data. Re-register them to start each scenario
    # like a fresh process, without a test-only reset endpoint.
    Sinatra::Application.reset!
    load File.expand_path('../app.rb', __dir__)
    Sinatra::Application.set :raise_errors, true
    Sinatra::Application.set :show_exceptions, false
    TEST_TRACE_EXPORTER.reset

    # OTLP uses Net::HTTP. Only the local fake collector may open a connection.
    allow(Net::HTTP).to receive(:new).and_wrap_original do |original, address, *args|
      raise "External HTTP is disabled in tests: #{address}" unless address == '127.0.0.1'
      original.call(address, *args)
    end
  end
  config.expect_with(:rspec) do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with(:rspec) { |mocks| mocks.verify_partial_doubles = true }
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.default_formatter = 'doc'
  config.order = :random
  Kernel.srand config.seed
end
