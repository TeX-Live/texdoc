require 'spec_helper'

RSpec.describe "View commands", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  ["dvi", "html", "pdf", "ps", "txt"].each do |ext|
    let("viewer_#{ext}".to_sym) {
      stderr.match(
        /Setting "viewer_#{ext}=\(?(\S*).*" from built-in defaults/).to_a[1]
    }
  end

  context "when to open a file" do
    before(:each) do
      set_environment_variable "PAGER_texdoc", "echo hello"

      run_texdoc "-dconfig --just-view", sample_txt
    end

    it "should be successfully executed" do
      expect(stdout).to include("hello")
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "if failed to execute" do
    before(:each) do
      set_environment_variable "PAGER_texdoc", "false"

      run_texdoc "-dconfig --just-view", sample_txt
    end

    it "should report the failure" do
      expect(last_command_started).to have_exit_status(1)
      expect(stderr).to include(error_line "Failed to execute: false")
    end
  end

  if not OS.windows?
    context "when they are not set" do
      before(:each) do
        delete_environment_variable "PAGER_texdoc"
        delete_environment_variable "BROWSER_texdoc"
        delete_environment_variable "DVIVIEWER_texdoc"
        delete_environment_variable "PSVIEWER_texdoc"
        delete_environment_variable "PDFVIEWER_texdoc"
        delete_environment_variable "MDVIEWER_texdoc"

        run_texdoc "-dconfig --just-view", sample_txt
      end

      it "should be guessed appropriately" do
        expect(which(viewer_dvi)).not_to be_nil
        expect(which(viewer_html)).not_to be_nil
        expect(which(viewer_pdf)).not_to be_nil
        expect(which(viewer_ps)).not_to be_nil
        expect(which(viewer_txt)).not_to be_nil
      end
    end
  end
end
