Given(/^I have installed the tool$/) do
end

# TODO: Add code to target fixture directory by default
When(/^I run it on the command line with the ([^ ]+) option$/) do |option|
  options = []
  if option.match(/\-\w$/)
    options << option
  else
    options << "--#{option}"
  end
  @run_result = run_check(options)
end

Then(/^the simple usage text should be displayed along with a non\-zero exit code$/) do
  refute_empty(@run_result[:stderr])
  refute_equal(@run_result[:exit_status], 0)
  assert_usage_message
end

Then(/^the simple usage text should be displayed along with a zero exit code$/) do
  assert_empty(@run_result[:stderr])
  assert_equal(@run_result[:exit_status], 0)
  assert_usage_message
end

Then(/^the current version should be displayed$/) do
  assert_match(/^ci-syntax-tool/, @run_result[:stdout], 'Version string should include tool name')
  assert_match(Regexp.new(Regexp.escape(CI::Syntax::Tool::VERSION)), @run_result[:stdout], 'Version string should include the version')
  assert_equal(@run_result[:stdout].split("\n").length, 1, 'Version output should be exactly one line long')
  assert_empty(@run_result[:stderr])
  assert_equal(@run_result[:exit_status], 0)
end
