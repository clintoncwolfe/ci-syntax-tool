module CI
  module Syntax
    module Tool
      # CI:Syntax::Tool::LanguageFactory
      #   Identifies and loads the Language classes, and
      # creates instances as needed.
      class LanguageFactory
        def self.all_languages
          []
        end
        def self.valid_language?(proposed)
          all_languages.map(&:name).include?(proposed)
        end
      end
    end
  end
end
