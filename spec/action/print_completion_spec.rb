require 'spec_helper'

RSpec.describe 'The "print-completion" action', :type => :aruba do
  include_context "messages"

  context "with --print-completion zsh" do
    before(:each) { run_texdoc "--print-completion zsh" }

    it do
      expect(stdout).to include("compdef __texdoc texdoc")
      expect(last_command_started).to be_successfully_executed
    end
  end
end
