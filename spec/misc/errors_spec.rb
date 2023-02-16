require 'spec_helper'

RSpec.describe "Errors", :type => :aruba do
  include_context "messages"

  let(:msg_usage) {
    <<~EXPECTED
      Try `texdoc --help' for short help, `texdoc texdoc' for full manual.
    EXPECTED
  }

  context "running without any option nor argument" do
    before(:each) { run_texdoc }

    it 'result in the "no action" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "No action specified.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context 'execute action the "just view" without an argument' do
    before(:each) { run_texdoc "--just-view" }

    it 'result in the "missing file operand" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "Missing file operand to --just-view.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context 'execute action the "print completion" without an argument' do
    before(:each) { run_texdoc "--print-completion" }

    it 'result in the "missing shell operand" error' do
      expect(last_command_started).to have_exit_status(2)
      expect(stderr).to include(error_line "Missing shell operand to --print-completion.")
      expect(stderr).to include(error_line msg_usage)
    end
  end

  context 'execute action the "print completion" with unsupported shell' do
    before(:each) { run_texdoc "--print-completion unrealistic-sh" }

    it 'result in the "missing shell operand" error' do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "unrealistic-sh is not supported currently!")
    end
  end

  context "missing arguments for Option -d" do
    before(:each) { run_texdoc "-d" }

    it 'result in a getopt parser error' do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Option -d requires an argument.")
    end
  end

  context "missing arguments for Option -c" do
    before(:each) { run_texdoc "-c" }

    it 'result in a getopt parser error' do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Option -c requires an argument.")
    end
  end

  context "when any document for input cannot be found" do
    let(:nonexist_pkg) { "never_never_existing_package_foooooooooo" }

    before(:each) { run_texdoc nonexist_pkg }

    it 'result in the "not found" error' do
      expect(stderr).to include("Unfortunately, there are no good matches for")
    end
  end
end
