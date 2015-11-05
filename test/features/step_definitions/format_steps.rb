require 'fileutils'

When(/^I run it on the command line with two format options and (\d) destination(?:s)$/) do |dest_count|
  options = [
    '--require', Dir.pwd + '/' + 'test/fixtures/require/mock_format.rb', 
    '--format', 'MockFormat',
    '--format', 'MockFormat',
  ]
  (0..(dest_count.to_i-1)).to_a.each do |i|
    options << '--output'
    options << 'test/tmp/dest-' + i.to_s
  end
  options << 'test/fixtures/files/clean'
  @run_result = run_check(options)
end

When(/^I run it on the command line with a destination in (the current directory|a directory that does not exist)$/) do |mode|
  path = 'output-create-test-1'
  options = [
    '--output'
  ]
  if mode == 'the current directory'
    FileUtils.rm_f path
    options << path
  else
    dir = 'test/tmp/output-create-dir'
    FileUtils.rm_f dir
    options << dir + '/' + path
  end
  options << 'test/fixtures/files/clean'
  @expected_output_paths = [ path ]
  @run_result = run_check(options)
end

When(/^I run it on the command line with the ([^ ]+) format on ([^ ]+) files$/) do |fmt_name, fixture|
  path = "test/tmp/#{fmt_name}.out"
  FileUtils.rm_f path
  options = [
    '--format', fmt_name,
    '--output', path,
    '--lang', 'YAML',
    "test/fixtures/files/#{fixture}",
  ]
  @expected_output_paths = [ path ]
  @run_result = run_check(options)
end

Then(/^I should get a list of the core formats along with a zero exit code$/) do
  assert_equal(0, @run_result[:exit_status])
  assert_format_list
end

Then(/^([^ ]+) should be included in the listed formats$/) do |fmt_name|
  actual = @run_result[:stdout].split("\n")
  assert_includes(actual, fmt_name)
end

Then(/^the file(?:s)? should be created$/) do
  @expected_output_paths.each do |path|
    assert(File.exist?(path), "#{path} should exist")
  end
end

