Then(/^I should get a list of the core languages along with a zero exit code$/) do
  assert_equal(0, @run_result[:exit_status])
  assert_language_list
end
