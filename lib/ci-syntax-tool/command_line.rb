module CI
  module Syntax
    module Tool
      class CommandLine

        attr_accessor :non_runnable_exit_status
        attr_reader :runnable
        
        def initialize(args)
          @runnable = false
          @non_runnable_exit_status = 0
          
        end

        def runnable?
          @runnable
        end
        
      end
    end
  end
end
