module CI
  module Syntax
    module Tool
      module Format
        # CI::Syntax::Tool::Format::Base
        #  Base class for syntax checkers.  Sketches out the
        #  API you need if you want to add a format.
        class Base

          attr_reader :out
          
          # Args is a hash, contents unspecified as yet.
          def initialize(io, args)
            @out = io
          end
          
          def self.descendant_classes
            # Fairly expensive call...
            ObjectSpace.each_object(Class).select { |klass| klass < self }
          end
          
          # Called once at the beginning of the check before any languages
          def overall_started(_overall_result)
          end

          # Called once at the beginning of the language check before any files
          def lang_started(_lang_result)
          end

          # Called once at the beginning of the check on a file.
          def file_started(_file_result)
          end

          # Called once at the end of the check on a file.
          def file_finished(_file_result)
          end

          # Invoked after all files are inspected, or interrupted by user.
          def lang_finished(_lang_result)
          end

          # Called once at the global finish
          def overall_finished(_overall_result)
          end
          
        end
      end
    end
  end
end
