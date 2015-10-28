module CI
  module Syntax
    module Tool
      # CI::Syntax::Tool::Checker
      #  Main driver of the tool.  For each language,
      #  locates files, runs the check, and outputs
      #  to each formatter.
      class Checker
        attr_reader :cmd_line

        def initialize(cmd_line)
        end
      end
    end
  end
end
