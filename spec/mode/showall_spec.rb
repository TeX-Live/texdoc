require 'spec_helper'

RSpec.describe 'The "showall" mode', :type => :aruba do
  include_context "messages"

  context "with -I" do
    before(:each) { run_texdoc "-sI", "texlive-en" }

    it "should show the result list without interaction" do
      expect(stdout).to match(/^ 1 .+\n 2 .+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with -M" do
    before(:each) { run_texdoc "-sM", "xetex" }
  
    it "should show the machine-readable list without interaction" do
      expect(stdout).to match(/^xetex\t\d(|\.\d)\t.+$/)
      expect(last_command_started).to be_successfully_executed
    end

    it 'should include even "bad" results' do
      expect(stdout).to match(/^xetex\t-\d(|\.\d)\t.+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  # Other interactive behaviors are completely same as the "list" mode.
  # Thus, we omit those checks here.
end
