# Convert RSpec's native JSON report using only Ruby's standard library.
require 'json'
require 'rexml/document'
require 'fileutils'

input_path, output_path = ARGV
abort 'Usage: ruby script/rspec_to_junit.rb INPUT.json OUTPUT.xml' unless input_path && output_path
report = JSON.parse(File.read(input_path))
summary = report.fetch('summary')
examples = report.fetch('examples')
load_errors = summary.fetch('errors_outside_of_examples_count', 0)

xml = REXML::Document.new
xml << REXML::XMLDecl.new('1.0', 'UTF-8')
suite = xml.add_element('testsuites').add_element('testsuite', {
  'name' => 'RSpec functional, integration and acceptance',
  'tests' => (examples.size + load_errors).to_s,
  'failures' => summary.fetch('failure_count').to_s,
  'errors' => load_errors.to_s,
  'skipped' => summary.fetch('pending_count').to_s,
  'time' => summary.fetch('duration').to_s
})
# XML 1.0 cannot represent the control characters sometimes found in errors.
clean = ->(value) { value.to_s.encode('UTF-8', invalid: :replace, undef: :replace).gsub(/[\x00-\x08\x0B\x0C\x0E-\x1F]/, '') }
examples.each do |example|
  test = suite.add_element('testcase', {
    'classname' => example.fetch('file_path'),
    'name' => clean.call(example.fetch('full_description')),
    'file' => example.fetch('file_path').sub(%r{\A\./}, ''),
    'line' => example.fetch('line_number').to_s,
    'time' => example.fetch('run_time').to_s
  })
  if example['status'] == 'failed'
    exception = example.fetch('exception', {})
    failure = test.add_element('failure', {
      'message' => clean.call(exception['message']), 'type' => clean.call(exception['class'])
    })
    failure.text = clean.call([exception['message'], *exception['backtrace']].join("\n"))
  elsif example['status'] == 'pending'
    test.add_element('skipped', 'message' => clean.call(example['pending_message']))
  end
end
load_errors.times do |index|
  test = suite.add_element('testcase', 'classname' => 'RSpec', 'name' => "Suite load error #{index + 1}")
  test.add_element('error', 'message' => 'RSpec failed outside an example').text = clean.call(report.fetch('messages', []).join("\n"))
end
FileUtils.mkdir_p(File.dirname(output_path))
File.open(output_path, 'w') { |file| xml.write(file) }
