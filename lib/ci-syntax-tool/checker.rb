module CI
  module Syntax
    module Tool
      # CI::Syntax::Tool::Checker
      #  Main driver of the tool.  For each language,
      #  locates files, runs the check, and outputs
      #  to each formatter.
      class Checker
        attr_reader :cmd_line
        attr_reader :overall_result

        def initialize(cmd_line)
          @cmd_line = cmd_line
        end

        def run
          @overall_result = Result::OverallResult.new()
          cmd_line.options[:languages].each do |lang_name|
            language_result = overall_result.add_language_result(lang_name)
            lang = LanguageFactory.create(lang_name)
            
            lang.check_starting(language_result)

            cmd_line.file_args.each do |argpath|
              if FileTest.directory?(argpath)
                Dir.chdir(argpath) do                  
                  Dir.glob(lang.combined_globs).each do |path|
                    file_result = language_result.add_file_result(path)
                    lang.check_file(file_result)
                  end
                end
              else
                # No glob check here - user explicitly specified a file
                file_result = language_result.add_file_result(argpath)
                lang.check_file(file_result)
              end
            end
            lang.check_ending(language_result)
          end

          return overall_result.report_failure? ? 1 : 0
          
        end
        
      end
    end
  end
end
