require 'spec_helper'

RSpec.describe "Verbose outputs", :type => :aruba do
  include_context "messages"

  context "with normal input" do
    before(:each) { run_texdoc "-v", "texlive-en" }

    it 'should include "view command" and "env" info' do
      info_viewcmd = info_line "View command: .+"
      info_env = info_line "Setting environment LC_CTYPE to: .+"
      expect(stderr).to match(Regexp.new(
        "^" + info_viewcmd + '\n' + info_env + '\Z'))
      expect(last_command_started).to be_successfully_executed
    end
  end
end
