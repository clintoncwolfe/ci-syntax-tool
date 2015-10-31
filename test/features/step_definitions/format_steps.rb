When(/^I run it on the command line with two format options and (\d) destination(?:s)$/) do |dest_count|
  options = [
    'require', 'test/fixtures/mocks/mock_format.rb', 
    'format', 'Mock',
    'format', 'Mock',
  ]
  (0..dest_count.to_i).to_a.each do |i|
    options << 'dest'
    options << 'test/tmp/dest-' + i.to_s
  end
  @run_result = run_check(options)
end


Then(/^I should get a list of the core formats along with a zero exit code$/) do
  assert_equal(0, @run_result[:exit_status])
  assert_format_list
end
