require 'spec_helper'

RSpec.describe 'The "just view" action', :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "with --just-view given an argument" do
    before(:each) { run_texdoc "--just-view", sample_txt }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with -v and --just-view given an argument" do
    before(:each) do
      run_texdoc "-v", "--just-view", sample_txt
    end

    it "should show the view command" do
      expect(stderr).to include(info_line "View command:")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "with --just-view without any argument" do
    before(:each) { run_texdoc "--just-view" }

    it 'should result in the "missing file operand" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "Missing file operand to --just-view.")
      expect(stderr).to include(error_line msg_usage)
    end
  end
end
