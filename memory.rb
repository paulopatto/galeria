require 'memory_profiler'

def run
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

memory_report = MemoryProfiler.report do
  run
end


puts 'Meassuring metrics ...'
memory_report.pretty_print(scale_bytes: true)
