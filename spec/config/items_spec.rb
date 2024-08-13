require 'os'
require 'spec_helper'
require 'fileutils'

RSpec.describe "Configuration item", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  context "texlive_tlpdb" do
    context "to set custom path" do
      before(:each) {
        run_texdoc "-dtlpdb", "-c texlive_tlpdb=#{ps_tlpdb.to_s}", "texlive-en"
      }

      it "should be effective" do
        expect(stderr).to include(
          debug_line "tlpdb", "Getting data from tlpdb file #{ps_tlpdb.to_s}")
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
