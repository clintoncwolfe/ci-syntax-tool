module CI
  module Syntax
    module Tool
      # CI::Syntax::Tool::CommandLine
      #   a class to parse and represent the CLI options
      class CommandLine
        attr_accessor :non_runnable_exit_status
        attr_reader :runnable

        # rubocop: disable MethodLength
        def initialize(args)
          @runnable = false
          @non_runnable_exit_status = 0
          @options = {
          }

          @parser = OptionParser.new do |opts|
            opts.banner = 'ci-syntax-tool [options] [path]'

            opts.on('-V', '--version',
                    'Show ci-syntax-tool version') do
              @options[:version] = true
            end

            opts.on('-h', '--help',
                    'Show this help message') do
              @options[:help] = true
            end
          end

          if args.include?('-V') || args.include?('--version')
            # Handle version case, which otherwise is eaten by optionparser
            @runnable = false
            @non_runnable_exit_status = 0
            puts 'ci-syntax-tool ' + CI::Syntax::Tool::VERSION
          elsif args.include?('-h') || args.include?('--help')
            # Handle help case, which otherwise is eaten by optionparser
            @runnable = false
            @non_runnable_exit_status = 0
            puts @parser.help
          else
            begin
              @parser.parse!(args)
            rescue OptionParser::InvalidOption => e
              e.recover args
            end
          end
        end
        # rubocop: enable MethodLength
 
        # rubocop: disable Style/TrivialAccessors
        def runnable?
          @runnable
        end
        # rubocop: enable Style/TrivialAccessors
      end
    end
  end
end
