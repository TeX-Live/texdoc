require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Fuzzy search", :type => :aruba do
  before(:all) { set_default_env }

  let(:stderr) { last_command_started.stderr }

  context "should not be performed if user input is right" do
    before(:each) { run_texdoc "-v", "texlive-en" }
    before(:each) { stop_all_commands }
    it { expect(stderr).not_to include(info_line "Fuzzy search result: ") }
  end

  context "should be performed if fuzzy_level > 0" do
    before(:each) { run_texdoc "-v -c fuzzy_level=1", "texlive-ex" }
    before(:each) { stop_all_commands }
    it { expect(stderr).to include(info_line "Fuzzy search result: ") }
  end

  context "should not be performed if fuzzy_level = 0" do
    before(:each) { run_texdoc "-v -c fuzzy_level=0", "texlive-ex" }
    before(:each) { stop_all_commands }
    it { expect(stderr).not_to include(info_line "Fuzzy search result: ") }
  end

  # TODO: check fuzzy search deliver the correct results
end
