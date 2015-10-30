require_relative './spec_helper'

RSpec.describe CI::Syntax::Tool::Issue, "#constructor" do  

  it "should be an error-level issue by default" do
    issue = CI::Syntax::Tool::Issue.new
    expect(issue.level).to be :error
  end

end

RSpec.describe CI::Syntax::Tool::Result::FileResult, "#issue counting" do
  it "should have zero issues by default" do
    fr = CI::Syntax::Tool::Result::FileResult.new('fake.yaml')
    expect(fr.warning_count).to eq 0
    expect(fr.error_count).to eq 0
  end
end
