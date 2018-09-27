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

  SAMPLE = "texlive-en"

  before(:all) { set_default_env }
  let(:stderr) { last_command_started.stderr }

  context "with an argument" do
    before(:each) { run_texdoc SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
  end

  context 'with option "-D"' do
    before(:each) { run_texdoc "-D", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "-D") }
  end

  context 'with option "--debug"' do
    before(:each) { run_texdoc "--debug", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "--debug") }
  end

  context 'with option "-dconfig"' do
    before(:each) { run_texdoc "-dconfig", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "-d") }
  end

  context 'with option "--debug=config"' do
    before(:each) { run_texdoc "--debug=config", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "--debug") }
  end

  context 'with option "-dconfig -lIv"' do
    before(:each) { run_texdoc "-dconfig", "-lIv", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=config", "-d") }
    it { expect(stderr).to include(set_cmo_line "mode=list", "-l") }
    it { expect(stderr).to include(set_cmo_line "interact_switch=false", "-I") }
    it { expect(stderr).to include(set_cmo_line "verbosity_level=3", "-v") }
  end

  context 'with option "-dconfig -wmls"' do
    before(:each) { run_texdoc "-dconfig", "-wmls", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "mode=view", "-w") }
    it { expect(stderr).to include(ignore_cmo_line "mode=mixed", "-m") }
    it { expect(stderr).to include(ignore_cmo_line "mode=list", "-l") }
    it { expect(stderr).to include(ignore_cmo_line "mode=showall", "-s") }
  end

  context 'with option "-D -Mdconfig"' do
    before(:each) { run_texdoc "-D", "-Mdconfig", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "debug_list=all", "-D") }
    it { expect(stderr).to include(set_cmo_line "machine_switch=true", "-M") }
    it { expect(stderr).to include(ignore_cmo_line "debug_list=config", "-d") }
  end

  context 'with option "-D -c fuzzy_level=0 -qv"' do
    before(:each) { run_texdoc "-D", "-c fuzzy_level=0", "-qv", SAMPLE }
    before(:each) { stop_all_commands }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(stderr).to include(set_cmo_line "fuzzy_level=0", "-c") }
    it { expect(stderr).to include(set_cmo_line "verbosity_level=0", "-q") }
    it { expect(stderr).to include(ignore_cmo_line "verbosity_level=3", "-v") }
  end
end
