require 'nokogiri'

Then(/^the generated files should be valid XML$/) do
  @expected_output_paths.each do |path|
    begin
      doc = File.open(path) { |f| Nokogiri::XML(f) }
      pass
    rescue
      flunk
    end
  end
end

Then(/^the jUnit files should have the correct structure$/) do
  @expected_output_paths.each do |path|
    doc = File.open(path) { |f| Nokogiri::XML(f) }
    assert_equal(1, doc.xpath('/testsuites').length, "It should have one root testsuites element")

    # It should have nonzero testsuite elements with a name attribute reflecting the language
    match = doc.xpath('/testsuites/testsuite')
    assert_equal(match.length > 0, "It should have nonzero testsuite elements")
    langs = CI::Syntax::Tool::LanguageFactory.all_language_names
    match.each do |node|
      assert_include(langs, node.at_xpath('@name'))
    end
    
    # It should have nonzero testcase elements, one per file, with name = sanitized filename
    match = doc.xpath('/testsuites/testsuite/testcase')
    assert_equal(match.length > 0, "It should have nonzero testcase elements")
    match.each do |node|
      file = node.at_xpath('@name')
      refute_empty(node.at_xpath('@name'), "testcase should have a name attribute")      
    end
        
    # It may have failure elements which must have a type=warning or error
    match = doc.xpath('/testsuites/testsuite/testcase/failure')
    match.each do |node|
      type = node.at_xpath('@type')
      assert_include(['warning', 'error'], type, "Each failure type should be either a warning or an error")
    end
  end

end

Then(/^the jUnit files should have (\d+) (error|warning)s$/) do |count, level|
  actual_count = 0
  @expected_output_paths.each do |path|
    doc = File.open(path) { |f| Nokogiri::XML(f) }
    actual_count += doc.xpath("//failure[@type=#{level}]").length
  end
  assert_equal(count, actual_count)
end
