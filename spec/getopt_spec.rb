require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Running Texdoc", :type => :aruba do
  before(:all) { set_default_env }
  let(:sample) { "texlive-en" }

  context "without any option and argument" do
    before(:each) { run_texdoc }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(2) }
    it { expect(last_command_started.stderr).to include("texdoc error: no action specified") }
  end

  context "with an argument" do
    before(:each) { run_texdoc sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with option -D" do
    before(:each) { run_texdoc ["-D", sample] }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stderr).to include("texdoc debug-version:") }
  end

  context "with option --debug" do
    before(:each) { run_texdoc ["--debug", sample] }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stderr).to include("texdoc debug-version:") }
  end

  context "with option -dconfig" do
    before(:each) { run_texdoc ["-dconfig", sample] }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stderr).to include("texdoc debug-config:") }
  end

  context "with option --debug=config" do
    before(:each) { run_texdoc ["--debug=config", sample] }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stderr).to include("texdoc debug-config:") }
  end

  context "with option -dconfig -lIV" do
    before(:each) { run_texdoc ["-dconfig", "-lIv", sample] }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
  end
end
