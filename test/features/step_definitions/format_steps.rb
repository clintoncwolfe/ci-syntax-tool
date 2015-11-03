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
  @run_result = run_check(options)
end


Then(/^I should get a list of the core formats along with a zero exit code$/) do
  assert_equal(0, @run_result[:exit_status])
  assert_format_list
end
