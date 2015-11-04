require 'yaml'

module CI
  module Syntax
    module Tool
      module Language
        # CI::Syntax::Tool::Language::Base
        #  Base class for syntax checkers.  Sketches out the
        #  API you need if you want to add a language.
        class YAML < Language::Base

          # Args is a hash, contents unspecified as yet.
          def initialize(args)
            super
          end
          
          def default_globs
            ['**/*.yaml', '**/*.yml']
          end
          
          # Called once for each file being checked.  
          # path [String] - path to filename to check
          # file_result [Result::File] - Results object for the outcome.
          # Returns: Result::File
          def check_file(file_result)
            begin
              ::YAML.load(File.read(file_result.path))
            rescue StandardError => e
              fail 
            end
          end
        end
      end
    end
  end
end
