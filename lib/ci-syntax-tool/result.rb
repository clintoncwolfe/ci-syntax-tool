module CI
  module Syntax
    module Tool
      
      class Issue
        attr_reader :line_number
        attr_reader :character
        attr_reader :raw_message
        attr_reader :cooked_message
        attr_reader :level
        def initialize(args = {})
          # Any may be nil, except for level
          @line_number = args[:line_number]
          @character = args[:character]
          @raw_message = args[:raw_message]
          @cooked_message = args[:cooked_message]
          @level = args[:level] || :error
        end
      end
      
      class Result

        class OverallResult < Result

          attr_reader :language_results
          
          def initialize
            @language_results = {}
          end

          def add_language_result(lang_name)
            language_results[lang_name] = LanguageResult.new(lang_name)
          end

          def report_failure?
            error_count > 0
          end

          def error_count
            language_results.inject(0) do |total, (lang,result)|
              total += result.error_count
            end
          end

          def warning_count
            language_results.inject(0) do |total, (lang,result)|
              total += result.error_count
            end
          end

          def file_paths
            files = []
            language_results.each do |ln, lr|
              lr.file_results.each do |fp, fr|
                files << fr.path
              end
            end
            files
          end
          
        end
        
        class LanguageResult < Result

          attr_reader :file_results
          attr_reader :language_name
          
          def initialize(lang_name)
            @language_name = lang_name
            @file_results = {}
          end

          def add_file_result(path)
            file_results[path] = FileResult.new(path)
          end

          def error_count
            file_results.inject(0) do |total, (path,result)|
              total += result.error_count
            end
          end

          def warning_count
            file_results.inject(0) do |total, (path,result)|
              total += result.warning_count
            end
          end
  
          def warning_file_results
            file_results.values.select { |fr| fr.warning_count > 0 }
          end
          
          def error_file_results
            file_results.values.select { |fr| fr.error_count > 0 }
          end
        
        end
        
        class FileResult < Result
          attr_reader   :path
          attr_reader  :issues
          
          def initialize(path)
            @path = path
            @whole_file_processed = false
            @issues = []
          end

          def add_issue(opts)
            issues << Issue.new(opts)
          end

          def warning_count
            warnings.count
          end

          def error_count
            errors.count
          end

          def warnings 
            issues.select { |i| i.level == :warning }
          end

          def errors 
            issues.select { |i| i.level == :error }
          end
          
        end
        
      end
    end
  end
end
