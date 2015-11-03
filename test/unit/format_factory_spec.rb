require_relative './spec_helper'

RSpec.describe CI::Syntax::Tool::FormatFactory, "#all_format_classes" do  

  it "should return  a list of Classes" do
    langs = CI::Syntax::Tool::FormatFactory.all_format_classes
    langs.each do |lang|
      expect(lang).to be_kind_of(Class)
    end
  end

end

RSpec.describe CI::Syntax::Tool::FormatFactory, "#all_format_names" do  

  it "should return a list of Strings" do
    lang_names = CI::Syntax::Tool::FormatFactory.all_format_names
    lang_names.each do |lang|
      expect(lang).to be_kind_of(String)
    end
  end

  it "should not return Base among the format names" do
    lang_names = CI::Syntax::Tool::FormatFactory.all_format_names
    expect(lang_names).not_to include('Base')
  end

  it "should include the expected format names" do
    lang_names = CI::Syntax::Tool::FormatFactory.all_format_names
    [
    ].each do |lang|
      expect(lang_names).to include(lang)
    end
  end
  
end

RSpec.describe CI::Syntax::Tool::FormatFactory, "#create" do
  it "should be able to create one of each format with a single arg" do
    CI::Syntax::Tool::FormatFactory.all_format_names.each do |fmt_name|      
      lang_obj = CI::Syntax::Tool::FormatFactory.create(fmt_name, 'test/tmp/dest-unit-0')
      expect(lang_obj).to be_kind_of CI::Syntax::Tool::Format::Base
    end
  end
end
