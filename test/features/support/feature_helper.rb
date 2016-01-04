require_relative '../../../lib/ci-syntax-tool'
require 'minitest'

require 'byebug'

module CI
  module Syntax
    module Tool
      module FeatureHelpers

        include MiniTest::Assertions

        attr_writer :assertions
        def assertions
          @assertions ||= 0
        end
        
        def run_check(command_line_args)

          # puts "RAW CLI: " + command_line_args.inspect # DEBUG
          
          # Capture any stdout and stderr
          sio_out = StringIO.new
          old_stdout = $stdout
          $stdout = sio_out
          sio_err = StringIO.new
          old_stderr = $stderr
          $stderr = sio_err

          overall_result = nil
          cli_opts = CI::Syntax::Tool::CommandLine.new(command_line_args)
          # puts "COOKED CLI: " + cli_opts.options.inspect # DEBUG
          if cli_opts.runnable?
            checker = CI::Syntax::Tool::Checker.new(cli_opts)
            exit_status = checker.run()
            overall_result = checker.overall_result
          else
            exit_status = cli_opts.non_runnable_exit_status
          end
          
          $stdout = old_stdout
          $stderr = old_stderr

          result = {
            stdout: sio_out.string,
            stderr: sio_err.string,
            exit_status: exit_status,
            overall_result: overall_result,
          }
          # puts "Results: " + result.inspect # DEBUG
          return result
          
        end

        def list_cli_opts
          return [
            {s: 'V', l: 'version', d: 'Show ci-syntax-tool version'},
            {s: 'h', l: 'help',    d: 'Show this help message'},
            {s: 'l', l: 'lang LANG',    d: 'Select this language for checking.  Repeatable.  Default, all languages.'},
            {        l: 'list-languages',    d: 'List available languages and exit.'},
            {s: 'f', l: 'format FORMAT',    d: 'Use this format for output.  Repeatable, but if repeated, must have an equal number of --output options.'},
            {s: 'o', l: 'output PATH',    d: 'Write formatted output to this location.  Use "-" to represent STDOUT.  Defaults to STDOUT if zero or one --format option used.  Repeatable with an equal number of --format options.'},
            {        l: 'list-formats',    d: 'List available formats and exit.'},
            {s: 'r', l: 'require RUBYFILE', d: 'Load additional Ruby code, perhaps for a custom language or format.  Repeatable.'},
            {s: 'd', l: 'debug', d: 'Provide debug-level output to STDOUT.'},
          ]          
        end

        def list_core_languages
          return [
            'Python',
            'YAML',
          ]
        end

        def list_core_formats
          return [
            'JUnit',
            'Progress',
          ]
        end

        def assert_usage_message
          list_cli_opts.each do |opt|
            re = '\s+'
            re += '-'     if opt[:s]
            re += opt[:s] if opt[:s]
            re += ','     if opt[:s]
            re += '\s+'
            re += '--' + opt[:l]
            re += '\s+'
            re += opt[:d]
            re += '\s+'
            assert_match(Regexp.new(re), @run_result[:stdout], "The '#{opt[:l]}' option should be present")
          end
          # TODO - check for spurious options?
        end

        def assert_language_list
          seen = @run_result[:stdout].split("\n").sort
          expected = list_core_languages.sort
          assert_equal(expected, seen, 'The list of supported languages should match')
        end

        def assert_format_list
          seen = @run_result[:stdout].split("\n").sort
          expected = list_core_formats.sort
          assert_equal(expected, seen, 'The list of supported formats should match')
        end

        def assert_class_loaded(klass)
          begin
            Kernel.const_get(klass)
          rescue NameError => e
            flunk("Expected Class #{klass} to have been loaded")
          rescue StandardError => e
            raise
          end
        end

        def files_matching_language(files, lang_name)
          globs = LanguageFactory.create(lang_name).combined_globs
          matches = []
          globs.each do |glob|
            re = glob.gsub('.', '\.')
            re = glob.gsub('**/', '.+')
            re = re.gsub('*', '.+')
            re += '$'
            re = Regexp.new(re)
            files.select {|fn1| fn1.match(re) }.each do |fn2|
              matches << fn2
            end
          end
          matches
        end
        
      end
    end
  end
end


World(CI::Syntax::Tool::FeatureHelpers)
