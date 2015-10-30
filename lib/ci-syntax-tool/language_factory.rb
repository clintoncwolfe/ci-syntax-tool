
# Load base class first
require_relative 'language/base'

# Load all core languages
Dir.glob(File.dirname(__FILE__) + '/language/*.rb') do |file|
  require_relative file
end

module CI
  module Syntax
    module Tool
      # CI:Syntax::Tool::LanguageFactory
      #   Identifies and loads the Language classes, and
      # creates instances as needed.
      class LanguageFactory
        
        def self.all_language_classes
          Language::Base.descendant_classes
        end

        def self.all_language_names
          class_names = all_language_classes.map(&:name)
          short_names = class_names.map do |name|
            name.split('::').last
          end
          short_names
        end

        def self.valid_language?(proposed)
          all_languages.names.include?(proposed)
        end

        def self.create(lang_name, args = {})
          const_get('CI::Syntax::Tool::Language::' + lang_name).new(args)
        end
        
      end
    end
  end
end
