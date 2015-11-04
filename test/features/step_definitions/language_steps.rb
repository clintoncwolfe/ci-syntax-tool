When(/^I run it on the command line specifying(?: the)? ([^ ]+) language(?:s)? and ([^ ]+) files$/) do |lang_name, fixture_group|
  options = [
    '--require', Dir.pwd + '/' + 'test/fixtures/require/mock_format.rb', 
    '--format', 'MockFormat',
  ]
  unless lang_name == 'all'
    options << '--lang'
    options << lang_name
  end
  options << 'test/fixtures/files/' + fixture_group

  @run_result = run_check(options)
end

Then(/^I should get a list of the core languages along with a zero exit code$/) do
  assert_equal(0, @run_result[:exit_status].to_i)
  assert_language_list
end

Then(/^the output should have (\d+) (error|warning)s$/) do |count, level|
  actual = @run_result[:overall_result].send((level +'_count').to_sym)
  assert_equal(count.to_i, actual)
end

Then(/^the output should show only files for ([^ ]+)$/) do |lang_name|
  touched = @run_result[:overall_result].file_paths
  matched = files_matching_language(touched, lang_name)
  extra = touched - matched
  assert_empty(extra, "The touched files should ONLY include files for #{lang_name}")
  refute_empty(matched, "The touched files should include files for #{lang_name}")
end


Then(/^the output should include files for ([^ ]+)$/) do | lang_name|
  touched = @run_result[:overall_result].file_paths
  matched = files_matching_language(touched, lang_name)
  refute_empty(matched, "The touched files should include files for #{lang_name}")
end

