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

RSpec.describe CI::Syntax::Tool::LanguageFactory, "#create" do
  it "should be able to create one of each language with no args" do
    CI::Syntax::Tool::LanguageFactory.all_language_names.each do |lang_name|      
      lang_obj = CI::Syntax::Tool::LanguageFactory.create(lang_name)
      expect(lang_obj).to be_kind_of CI::Syntax::Tool::Language::Base
    end
  end
end
