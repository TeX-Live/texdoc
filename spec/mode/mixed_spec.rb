require 'spec_helper'

RSpec.describe 'The "mixed" mode', :type => :aruba do
  include_context "messages"

  context "in case the result size > 1" do
    before(:each) { run_texdoc "-mI", "texlive-en" }

    it "should show the result list" do
      expect(stdout).to match(/^ 1 .+\n 2 .+$/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "in case the result size = 1" do
    before(:each) { run_texdoc "-c ext_list=pdf", "-mvI", "kpathsea" }
  
    it 'should open a file without interaction' do
      expect(stderr).to include(info_line "View command: ")
      expect(last_command_started).to be_successfully_executed
    end
  end

  # Other behaviors are same as the "list" mode or "view" mode.
  # Thus, we omit those checks here.
end
