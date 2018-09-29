require 'spec_helper'
require 'texdoc_helper'

RSpec.configure do |c|
  c.include Helplers
end

RSpec.describe "Errors", :type => :aruba do
  include_context "messages"

  let(:stderr) { last_command_started.stderr.gsub("\r", "") }
  let(:nonexist_pkg) { "never_never_existing_package_foooooooooo" }
  let(:msg_not_found) do
    <<~EXPECTED
      Sorry, no documentation found for #{nonexist_pkg}.
      If you are unsure about the name, try searching CTAN's TeX catalogue at
      https://ctan.org/search.html#byDescription.
    EXPECTED
  end
  let(:msg_usage) do
    "Try `texdoc --help' for short help, `texdoc texdoc' for full manual."
  end

  before(:all) { set_default_env }

  context "running without any option nor argument" do
    before(:each) { run_texdoc }
    before(:each) { stop_all_commands }

    it 'result in the "no action" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "No action specified.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context 'execute action the "just view" without an argument' do
    before(:each) { run_texdoc "--just-view" }
    before(:each) { stop_all_commands }

    it 'result in the "missing file operand" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "Missing file operand to --just-view.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context "when any document for input cannot be found" do
    before(:each) { run_texdoc nonexist_pkg }
    before(:each) { stop_all_commands }

    it 'result in the "not found" error' do
      expect(stderr).to include(msg_not_found)
      expect(last_command_started).to have_exit_status(3)
    end
  end
end
