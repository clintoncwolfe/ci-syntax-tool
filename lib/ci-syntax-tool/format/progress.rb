module CI
  module Syntax
    module Tool
      module Format
        # CI::Syntax::Tool::Format::Progress
        #  Prints a dot for each 
        #  API you need if you want to add a format.
        class Progress < Format::Base

          def initialize(io, args)
            super
          end

          def started(lang_result)
            out.puts "Starting syntax scan for #{lang_result.language_name}..."
          end
          
          # Called once at the end of the check on a file.
          def file_finished(file_result)
            if file_result.error_count > 0  
              out.print 'x'
            elsif file_result.warning_count > 0
              out.print '*'
            else
              out.print '.'
            end
          end

          # Invoked after all files are inspected, or interrupted by user.
          def finished(lang_result)
            out.puts

            if lang_result.warning_count > 0
              out.puts 'Files with warnings:'
              
              lang_result.warning_file_results.each do |fr|
                puts '  ' + fr.path
                fr.warnings.each do |w|
                  puts '    ' + (w.line_number.to_s || '?') + ':' + (w.character.to_s || '?') + ':' + w.raw_message
                end
              end
            end

            if lang_result.error_count > 0
              out.puts 'Files with errors:'
              
              lang_result.error_file_results.each do |fr|
                puts '  ' + fr.path
                fr.errors.each do |e|
                  puts '    Line ' + (e.line_number.to_s || '?') + ': Col ' + (e.character.to_s || '?') + ':' + e.raw_message
                end
              end
            end

          end          
        end
      end
    end
  end
end
