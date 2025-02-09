require 'spec_helper'

RSpec.describe 'The "print completion" action', :type => :aruba do
  include_context "messages"

  context "with --print-completion zsh" do
    before(:each) { run_texdoc "--print-completion zsh" }

    it do
      expect(stdout).to include("compdef __texdoc texdoc")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "without any argument" do
    before(:each) { run_texdoc "--print-completion" }

    it 'should result in the "missing shell operand" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "Missing shell operand to --print-completion.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context "with unsupported shel" do
    before(:each) { run_texdoc "--print-completion unrealistic-sh" }

    it 'should result in the "missing shell operand" error' do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "unrealistic-sh is currently not supported.")
    end
  end

end
