When(/^I run it on the command line with the require option and a (valid|invalid|missing) ruby file$/) do |require_file|
  options = [
    '--require', 'test/fixtures/require/' + require_file + '.rb'
  ]
  @run_result = run_check(options)
end

When(/^I run it on the command line with two requires$/) do
  options = [
    '--require', 'test/fixtures/require/valid.rb',
    '--require', 'test/fixtures/require/second.rb',
  ]
  @run_result = run_check(options)
end

Then(/^I should get an error message about the (missing|invalid) require file$/) do |which_require|
  assert_match(Regexp.new("Could not load .+ because it appears to be #{which_require}."), @run_result[:stderr])
  assert_equal(1, @run_result[:stderr].split("\n").length, 'Stderr should be a single line, not a nasty stacktrace') # Possibly regrettable - add debug flag?
  assert_empty(@run_result[:stdout], 'Stdout should be silent')
end

Then(/^the (valid|first|second) ruby file should have been loaded$/) do |which_require|
  klass_name = which_require == 'first' ? 'valid' : which_require
  klass_name.capitalize!
  klass_name = 'CI::Syntax::Tool::Test::' + klass_name + 'Require'
  assert_class_loaded(klass_name)
end
