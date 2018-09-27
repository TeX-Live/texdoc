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

  let(:sample) { "texlive-en" }

  before(:all) { set_default_env }
  let(:stderr) { last_command_started.stderr }

  context "with an argument" do
    before(:each) { run_texdoc sample }
    before(:each) { stop_all_commands }

    it { expect(last_command_started).to be_successfully_executed }
  end

  context 'with option "-D"' do
    before(:each) { run_texdoc "-D", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=all", "-D")
    end
  end

  context 'with option "--debug"' do
    before(:each) { run_texdoc "--debug", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=all", "--debug")
    end
  end

  context 'with option "-dconfig"' do
    before(:each) { run_texdoc "-dconfig", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=config", "-d")
    end
  end

  context 'with option "--debug=config"' do
    before(:each) { run_texdoc "--debug=config", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=config", "--debug")
    end
  end

  context 'with option "-dconfig -lIv"' do
    before(:each) { run_texdoc "-dconfig", "-lIv", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=config", "-d")
      expect(stderr).to include(set_cmo_line "mode=list", "-l")
      expect(stderr).to include(set_cmo_line "interact_switch=false", "-I")
      expect(stderr).to include(set_cmo_line "verbosity_level=3", "-v")
    end
  end

  context 'with option "-dconfig -wmls"' do
    before(:each) { run_texdoc "-dconfig", "-wmls", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "mode=view", "-w")
      expect(stderr).to include(ignore_cmo_line "mode=mixed", "-m")
      expect(stderr).to include(ignore_cmo_line "mode=list", "-l")
      expect(stderr).to include(ignore_cmo_line "mode=showall", "-s")
    end
  end

  context 'with option "-D -Mdconfig"' do
    before(:each) { run_texdoc "-D", "-Mdconfig", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "debug_list=all", "-D")
      expect(stderr).to include(set_cmo_line "machine_switch=true", "-M")
      expect(stderr).to include(ignore_cmo_line "debug_list=config", "-d")
    end
  end

  context 'with option "-D -c fuzzy_level=0 -qv"' do
    before(:each) { run_texdoc "-D", "-c fuzzy_level=0", "-qv", sample }
    before(:each) { stop_all_commands }

    it do
      expect(last_command_started).to be_successfully_executed
      expect(stderr).to include(set_cmo_line "fuzzy_level=0", "-c")
      expect(stderr).to include(set_cmo_line "verbosity_level=0", "-q")
      expect(stderr).to include(ignore_cmo_line "verbosity_level=3", "-v")
    end
  end
end
