
require 'rake'
require 'rake/tasklib'

module CI
  module Syntax
    module Tool
      
      # Provides a custom rake task.
      #
      # require 'ci-syntax-tool/rake_task'
      # CI::Syntax::Tool::RakeTask.new
      class RakeTask < Rake::TaskLib
        attr_accessor :name
        attr_accessor :fail_on_error
        attr_accessor :verbose
        attr_accessor :languages
        attr_accessor :outputs
        attr_accessor :formats
        attr_accessor :options

        def initialize(*args, &task_block)
          setup_ivars(args)

          desc 'Run syntax checks' unless ::Rake.application.last_comment

          task(name, *args) do |_, task_args|
            RakeFileUtils.send(:verbose, verbose) do
              if task_block
                task_block.call(*[self, task_args].slice(0, task_block.arity))
              end
              run_main_task(verbose)
            end
          end
        end

        def run_main_task(verbose)
          run_cli(verbose, full_options)
        end

        private

        def run_cli(verbose, options)
          require 'ci-syntax-tool'

          cli_opts = CommandLine.new(options)
          puts 'Running ci-syntax-tool...' if verbose
          result = Checker.new(cli_opts).run
          abort('Syntax checks failed!') if result != 0 && fail_on_error
        end

        def full_options
          [].tap do |result|
            result.concat(formats.map { |f| ['--format', f] }.flatten)
            result.concat(outputs.map { |o| ['--output', o] }.flatten)
            result.concat(languages.map { |l| ['--output', l] }.flatten)
            result.concat(options)
          end
        end
        
        def setup_ivars(args)
          @name = args.shift || :syntax
          @verbose = true
          @fail_on_error = true
          @languages = []
          @formats = []
          @options = []
          @outputs = []
        end
        
      end
    end
  end
end
