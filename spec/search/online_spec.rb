require 'spec_helper'
require 'pathname'

RSpec.describe "Online searches", :type => :aruba do
  include_context "messages"

  context "with no local docs" do
    before(:each) { set_environment_variable "TEXDOC_NO_LOCAL_DOCS", "true" }
    before(:each) { set_environment_variable "TEXDOCS", "{}" }
    before(:each) {
      run_texdoc \
        "-dtlpdb",
        "-c texlive_tlpdb=" + Pathname.pwd.to_s + "/spec/support/no-docs.tlpdb",
        "lua-widow-control"
    }

    it 'should say no docs installed' do
      expect(stderr).to include(
        "You don't appear to have any local documentation installed."
    )
    end
  end

  context "bad fuzzy results" do
    before(:each) { run_texdoc "-i", "scrgui" }

    it 'should say no good matches' do
      expect(stderr).to include(
        "Unfortunately, I couldn't find any good matches"
    )
    end
  end

  context "bad fuzzy results in the list mode" do
    before(:each) { run_texdoc "-il", "scrgui", interactive: true }
    before(:each) { type "\n" }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
    end
  end
end
