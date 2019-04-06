require 'os'
require 'spec_helper'
require 'pathname'
require 'fileutils'

RSpec.describe "Configuration item", :type => :aruba do
  include_context "messages"

  context "texlive_tlpdb" do
    context "to set custom path" do
      let(:tlpdb) { Pathname.pwd + "tmp/texlive.tlpdb" }
      let(:texmf_var) { Pathname.pwd + "tmp/texmf-var" }

      before(:each) { set_environment_variable "TEXMFVAR", texmf_var.to_s }
      before(:each) {
        run_texdoc "-dtlpdb", "-c texlive_tlpdb=#{tlpdb.to_s}", "texlive-en"
      }

      after(:each) { FileUtils.remove_dir(texmf_var) }

      it "should be effective" do
        expect(stderr).to include(
          debug_line "tlpdb", "Getting data from tlpdb file #{tlpdb.to_s}")
      end
    end

    context "to set invalid path" do
      before(:each) { run_texdoc "-dtlpdb", "-c texlive_tlpdb=foo", "texlive-en" }

      it "should output warnings" do
        expect(stderr).to include(
          warning_line "Specified texlive.tlpdb does not exist: foo")
        expect(stderr).to include(
          warning_line "Fallback to use the texlive.tlpdb in the distribution.")
      end
    end
  end
end
