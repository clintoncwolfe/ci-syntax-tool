require_relative './spec_helper'

RSpec.describe CI::Syntax::Tool::LanguageFactory, "#all_language_classes" do  

  it "should return  a list of Classes" do
    langs = CI::Syntax::Tool::LanguageFactory.all_language_classes
    langs.each do |lang|
      expect(lang).to be_kind_of(Class)
    end
  end

end

RSpec.describe CI::Syntax::Tool::LanguageFactory, "#all_language_names" do  

  it "should return a list of Strings" do
    lang_names = CI::Syntax::Tool::LanguageFactory.all_language_names
    lang_names.each do |lang|
      expect(lang).to be_kind_of(String)
    end
  end

  it "should not return Base among the language names" do
    lang_names = CI::Syntax::Tool::LanguageFactory.all_language_names
    expect(lang_names).not_to include('Base')
  end

  it "should include the expected language names" do
    lang_names = CI::Syntax::Tool::LanguageFactory.all_language_names
    [
    ].each do |lang|
      expect(lang_names).to include(lang)
    end
  end

end

