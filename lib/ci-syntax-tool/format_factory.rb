
# Load base class first
require_relative 'format/base'

# Load all core formats
Dir.glob(File.dirname(__FILE__) + '/format/*.rb') do |file|
  require_relative file
end

module CI
  module Syntax
    module Tool
      # CI:Syntax::Tool::FormatFactory
      #   Identifies and loads the Format classes, and
      # creates instances as needed.
      class FormatFactory
        
        def self.all_format_classes
          Format::Base.descendant_classes
        end

        def self.all_format_names
          class_names = all_format_classes.map(&:name)
          short_names = class_names.map do |name|
            name.split('::').last
          end
          public_names = short_names.reject {|e| e == 'MockFormat'}
          public_names
        end

        def self.valid_format?(proposed)
          permitted_names = all_format_names << 'MockFormat'
          permitted_names.include?(proposed)
        end

        def self.create(lang_name, io, args = {})
          const_get('CI::Syntax::Tool::Format::' + lang_name).new(io, args)
        end
        
      end
    end
  end
end
