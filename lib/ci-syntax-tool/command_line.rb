
require 'optparse'

module CI
  module Syntax
    module Tool
      # CI::Syntax::Tool::CommandLine
      #   a class to parse and represent the CLI options
      #   also handles degenerate CLI cases, like --help,
      #   --version, --list-languages, --list-formatters
      class CommandLine
        attr_accessor :non_runnable_exit_status
        attr_reader :languages
        attr_reader :formatters
        attr_reader :options
        
        def initialize(args)
          @args = args.dup
          @runnable = true
          @non_runnable_exit_status = 0
          @options = {
            languages: [],
            requires: [],
          }
          
          @parser = make_parser

          parse_args
          load_requires if runnable?
          validate_languages if runnable?
          list_languages if runnable? && @options[:list_languages]
          
        end

        # rubocop: disable Style/TrivialAccessors
        def runnable?
          @runnable
        end
        # rubocop: enable Style/TrivialAccessors
        
        private
        
        # rubocop: disable MethodLength
        def make_parser
          ::OptionParser.new do |opts|
            opts.banner = 'ci-syntax-tool [options] [path]'

            opts.on('-V', '--version',
                    'Show ci-syntax-tool version') do
              @options[:version] = true
            end

            opts.on('-h', '--help',
                    'Show this help message') do
              @options[:help] = true
            end

            opts.on('-l', '--lang LANG',
                    'Select this language for checking.  Repeatable.' \
                    '  Default, all languages.') do |lang|
              @options[:languages] << lang
            end

            opts.on('--list-languages',
                    'List available languages and exit.') do
              @options[:list_languages] = true
            end

            opts.on('-r', '--require RUBYFILE',
                    'Load additional Ruby code, perhaps for a custom ' \
                    'language or format.  Repeatable.') do |r|
              @options[:requires] << r
            end
          end
        end
        # rubocop: enable MethodLength

        def parse_args
          if @args.include?('-V') || @args.include?('--version')
            # Handle version case, which otherwise is eaten by optionparser
            @runnable = false
            @non_runnable_exit_status = 0
            puts 'ci-syntax-tool ' + CI::Syntax::Tool::VERSION

          elsif @args.include?('-h') || @args.include?('--help')
            # Handle help case, which otherwise is eaten by optionparser
            @runnable = false
            @non_runnable_exit_status = 0
            puts @parser.help
          else
            begin
              @parser.parse!(@args)
            rescue OptionParser::InvalidOption => e
              e.recover @args
            end
          end
        end

        def list_languages
          LanguageFactory.all_language_names.sort.each do |lang_name|
            puts lang_name
          end
          @runnable = false
        end

        def validate_languages
          @options[:languages].each do |lang_opt|
            next if LanguageFactory.valid_language?(lang_opt)
            
            $stderr.puts "'#{lang_opt}' is not a valid language"
            @runnable = false
            @non_runnable_exit_status = 3
          end
        end

        def load_requires
          @options[:requires].each do |require_path|

            if File.exist?(require_path)
              begin
                path = require_path.sub(/\.rb$/,'')
                require require_path
              rescue Exception => e # TODO: probably bad idea to catch this
                # TODO: cosider adding a --debug flag to allow dumping the stacktrace.
                $stderr.puts "Could not load #{require_path} because it appears to be invalid."
                @runnable = false
                @non_runnable_exit_status = 5                
                break
              end
            else
              $stderr.puts "Could not load #{require_path} because it appears to be missing."
              @runnable = false
              @non_runnable_exit_status = 5
              break
            end
          end
        end
        
      end
    end
  end
end
