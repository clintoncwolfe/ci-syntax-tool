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

Then(/^the JUnit files should have the correct structure$/) do
  @expected_output_paths.each do |path|

    # puts "POINT A:" + path
    
    doc = File.open(path) { |f| Nokogiri::XML(f) }

    # puts "POINT B:" + doc.to_s
    assert_equal(1, doc.xpath('/testsuites').length, "It should have one root testsuites element")

    # It should have nonzero testsuite elements with a name attribute reflecting the language
    match = doc.xpath('/testsuites/testsuite')
    assert(match.length > 0, "It should have nonzero testsuite elements")
    langs = CI::Syntax::Tool::LanguageFactory.all_language_names
    match.each do |node|
      assert_includes(langs, node.at_xpath('@name').to_s)
    end
    
    # It should have nonzero testcase elements, one per file, with name = sanitized filename
    match = doc.xpath('/testsuites/testsuite/testcase')
    assert(match.length > 0, "It should have nonzero testcase elements")
    match.each do |node|
      file = node.at_xpath('@name').to_s
      refute_empty(file, "testcase should have a name attribute")
    end
        
    # It may have failure elements which must have a type=warning or error
    match = doc.xpath('/testsuites/testsuite/testcase/failure')
    match.each do |node|
      type = node.at_xpath('@type').to_s
      assert_includes(['warning', 'error'], type, "Each failure type should be either a warning or an error")
    end
  end

end

Then(/^the JUnit files should have (\d+) (error|warning)s$/) do |count, level|
  actual_count = 0
  @expected_output_paths.each do |path|
    doc = File.open(path) { |f| Nokogiri::XML(f) }
    actual_count += doc.xpath("//failure[@type=\"#{level}\"]").length
  end
  assert_equal(count.to_i, actual_count)
end
