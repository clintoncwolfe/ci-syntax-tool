module CI
  module Syntax
    module Tool
      # CI::Syntax::Tool::CommandLine
      #   a class to parse and represent the CLI options
      class CommandLine
        attr_accessor :non_runnable_exit_status
        attr_reader :runnable

        def initialize(args)
          @runnable = false
          @non_runnable_exit_status = 0
        end

        # rubocop: disable Style/TrivialAccessors
        def runnable?
          @runnable
        end
        # rubocop: enable Style/TrivialAccessors
      end
    end
  end
end
