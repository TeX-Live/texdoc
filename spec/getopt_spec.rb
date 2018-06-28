require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Running Texdoc", :type => :aruba do
  def set_cmo_line(config, opt)
    debug_line "config", "Setting \"#{config}\" from command line option \"#{opt}\"."
  end

  def ignore_cmo_line(config, opt)
    debug_line "config", "Ignoring \"#{config}\" from command line option \"#{opt}\"."
  end

  before(:all) { set_default_env }

  let(:sample) { "texlive-en" }
  let(:stderr) { last_command_started.stderr }

  context "without any option and argument" do
    before(:each) { run_texdoc }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to have_exit_status(2) }
    it { expect(stderr).to include(error_line "no action specified") }
  end

  context "with an argument" do
    before(:each) { run_texdoc sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
  end

  context "with option -D" do
    before(:each) { run_texdoc "-D", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "-D") }
  end

  context "with option --debug" do
    before(:each) { run_texdoc "--debug", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "--debug") }
  end

  context "with option -dconfig" do
    before(:each) { run_texdoc "-dconfig", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "-d") }
  end

  context "with option --debug=config" do
    before(:each) { run_texdoc "--debug=config", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "--debug") }
  end

  context "with option -dconfig -lIv" do
    before(:each) { run_texdoc "-dconfig", "-lIv", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "-d") }
    it { expect(stderr).to include(set_cmo_line "mode=list", "-l") }
    it { expect(stderr).to include(set_cmo_line "interact_switch=false", "-I") }
    it { expect(stderr).to include(set_cmo_line "verbosity_level=3", "-v") }
  end

  context "with option -dconfig -wmls" do
    before(:each) { run_texdoc "-dconfig", "-wmls", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "mode=view", "-w") }
    it { expect(stderr).to include(ignore_cmo_line "mode=mixed", "-m") }
    it { expect(stderr).to include(ignore_cmo_line "mode=list", "-l") }
    it { expect(stderr).to include(ignore_cmo_line "mode=showall", "-s") }
  end

  context "with option -D -Mdconfig" do
    before(:each) { run_texdoc "-D", "-Mdconfig", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "-D") }
    it { expect(stderr).to include(set_cmo_line "machine_switch=true", "-M") }
    it { expect(stderr).to include(ignore_cmo_line "debug_list=config", "-d") }
  end

  context "with option -dconfig -qv" do
    before(:each) { run_texdoc "-dconfig", "-qv", sample }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "-d") }
    it { expect(stderr).to include(set_cmo_line "verbosity_level=0", "-q") }
    it { expect(stderr).to include(ignore_cmo_line "verbosity_level=3", "-v") }
  end
end
