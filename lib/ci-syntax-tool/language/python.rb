require 'fileutils'

module CI
  module Syntax
    module Tool
      module Language
        class Python < Language::Base

          attr_reader :python_bin
          
          def initialize(args)
            super
            @python_bin = `which python`.chomp
          end
          
          def default_globs
            ['**/*.py']
          end


          # Called once before any files are checked
          # An opportunity to spawn a process, for example.
          # TODO: consider spawning a python process, reading filenames
          # see this: http://stackoverflow.com/a/4284526/3284458
          def check_starting(_lang_result)
          end

          
          # Called once for each file being checked.  
          # path [String] - path to filename to check
          # file_result [Result::File] - Results object for the outcome.
          # Returns: Result::File
          def check_file(file_result)
            # A clean compile will emit silence to STDERR and STDOUT, and leave behind a pyc file.
            output = `#{python_bin} -m py_compile #{file_result.path} 2>&1`

            # Errors look like this, with no newline (so far:
            # Sorry: IndentationError: unexpected indent (bad-indentation.py, line 4)
            output.scan(/Sorry:\s+(.+):\s+(.+)\s+\((.+),\s+line\s+(\d+)\)/).each do |match|
              file_result.add_issue(
                line_number: match[3],
                level: :error,
                raw_message: match[1],
              )
            end

            # Check for and delete a PYC file if one was created.
            pyc_file = file_result.path + 'c'
            if File.exist?(pyc_file) then
              FileUtils.rm(pyc_file)
            end
          end


          # Called once after all files are checked
          # Use for cleanup, or adding metadata to
          # the result.
          # result [Language::Result] - populated
          # results of the run.
          # TODO: shutdown sub proc
          def check_ending(_result)
          end
          
        end
      end
    end
  end
end
