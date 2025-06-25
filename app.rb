require 'sinatra'
require 'bundler'
require 'memory_profiler'
enable :sessions

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

get '/metrics' do
  memory_report = MemoryProfiler.report do
    start_time = Time.now
    puts 'Loading ...'
    data = File.read 'twelve_bytes.txt'
    load_time = (((Time.now - start_time) % 3600) % 60).to_i
    puts "Loaded large file in #{load_time} seconds. "

    puts 'Sorting ...'
    data.split('').sort
    total_time = (((Time.now - start_time) % 3600) % 60).to_i
    puts "End computing in #{total_time} seconds. "
  end

  "Mem usage: #{memory_report.total_allocated_memsize / 1024 / 1024}Mb"

end

get '/fibonacci' do
  start_time = Time.now
  num = params['num'].to_i || 7
  f = ->(x){ x < 2 ? x : f[x-1] + f[x-2] }

  fib = f.(num)
  total_time = (((Time.now - start_time) % 3600) % 60).to_i
  "Fibonacci: #{fib.to_s} <br /> Time: #{total_time} seconds. at #{Time.now.to_time}"
end

def metrics
end
