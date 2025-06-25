source 'https://rubygems.org'
gem 'sinatra', '~> 2.0.X'

# OTEL
gem 'opentelemetry-common'
gem 'opentelemetry-sdk'
gem 'opentelemetry-exporter-otlp'
gem 'opentelemetry-instrumentation-rack'
gem 'opentelemetry-exporter-jaeger'
# gem 'opentelemetry-exporter-otlp-metrics'
# gem 'opentelemetry-exporter-otlp-grpc'
# gem 'opentelemetry-exporter-otlp-http'


group :development do
  gem 'pry-byebug'
end

group :test, :development do
  gem 'dotenv', '~> 2.7.X'
  gem 'thin', '2.0.1'
end

group :test do
  gem 'rspec', '~> 3.9.X'
  gem 'rack-test', '~> 1.1.0'
end

group :production do
  gem 'foreman'
end
