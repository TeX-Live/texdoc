require 'os'
require 'spec_helper'

RSpec.describe "System locale", :type => :aruba do
  include_context "messages"

  if OS.mac?
    context "if an environment variable is set" do
      before(:each) { set_environment_variable "LC_ALL", "en_US.UTF-8" }
      before(:each) { run_texdoc "-dconfig", "texlive-en" }

      it "should be ignored" do
        expect(stderr).to include(
          debug_line "config",
            "Ignoring \"lang=en\" from operating system locale.")
      end
    end
  end
end
