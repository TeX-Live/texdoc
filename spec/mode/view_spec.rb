require 'spec_helper'

RSpec.describe 'The "view" mode', :type => :aruba do
  include_context "messages"

  context "with normal input" do
    before(:each) { run_texdoc "-dconfig", "-wv", "texlive-en" }

    it 'should open a file without interaction' do
      expect(stderr).to include(info_line "View command: ")
      expect(last_command_started).to be_successfully_executed
    end
  end
end
