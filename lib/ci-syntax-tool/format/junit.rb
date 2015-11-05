require 'nokogiri'

module CI
  module Syntax
    module Tool
      module Format
        # CI::Syntax::Tool::Format::Progress
        #  Prints a dot for each 
        #  API you need if you want to add a format.
        class JUnit < Format::Base
          attr_reader :doc
          attr_reader :root
          attr_reader :testsuite  # Equiv to lang
          attr_reader :testcase   # Equiv to file
          
          def initialize(io, args)
            super
            @doc = Nokogiri::XML::Document.new()
            @root = Nokogiri::XML::Element.new('testsuites', doc)
            doc.add_child(root)            
          end

          def lang_started(lang_result)
            @testsuite = Nokogiri::XML::Element.new('testsuite', doc)
            testsuite['name'] = lang_result.language_name
            root.add_child(testsuite)
          end

          def file_started(file_result)
            @testcase = Nokogiri::XML::Element.new('testcase', doc)
            testcase['name'] = file_result.path.gsub('/','_').gsub('.','_')
            testsuite.add_child(testcase)
          end
          
          def file_finished(file_result)
            file_result.issues.each do |issue|
              failure = Nokogiri::XML::Element.new('failure', doc)
              failure['type'] = issue.level.to_s
              message = Nokogiri::XML::CDATA.new(doc, issue.cooked_message || issue.raw_message)
              failure.add_child(message)
              testcase.add_child(failure)
            end
          end

          def overall_finished(overall_result)
            out.write doc.to_s
            out.flush
          end
          
        end
      end
    end
  end
end
