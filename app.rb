require 'bundler'
require 'sinatra'
require './otel-middleware'

if %w[development test].include?(ENV['RACK_ENV'] || 'development')
  require 'dotenv'
  Dotenv.load
end

enable :sessions
use OpenTelemetryMiddleware

id_counter = 1
images = []

post '/' do
  img_num = rand(0..1084)
  images << {
    id: id_counter,
    url: "https://unsplash.it/600/500?image=#{img_num}",
    title: "Picture number #{id_counter}"
  }
  id_counter += 1
  redirect '/'
end

get '/' do
  @images = images
  erb :index
end

get '/photo/:id' do
  @image = images.select { |img| img[:id] == params[:id].to_i }.first
  erb :single
end

get '/docs' do
  send_file 'docs.html'
end

get '/swagger.yaml' do
  send_file 'swagger.yaml'
end