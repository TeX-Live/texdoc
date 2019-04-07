require 'spec_helper'

RSpec.describe 'The "files" action', :type => :aruba do
  include_context "version"
  include_context "messages"
  include_context "texmf"

  context "executing" do
    context "with --files" do
      before(:each) { run_texdoc "--files" }

      it { expect(last_command_started).to be_successfully_executed }
    end

    context "with -f" do
      before(:each) { run_texdoc "-f" }

      it { expect(last_command_started).to be_successfully_executed }
    end

    context "with -f -l" do
      before(:each) { run_texdoc "-f -l" }

      it { expect(last_command_started).to be_successfully_executed }
    end
  end

  context "the output" do
    # known files
    let(:texdoclib) { texmf_home + "scripts/texdoc/texdoclib.tlu" }

    let(:dist_texdoc_dist_cnf) { texmf_dist + "texdoc/texdoc-dist.cnf" }
    let(:dist_texdoc_cnf) { texmf_dist + "texdoc/texdoc.cnf" }

    let(:home_texdoc_dist_cnf) { texmf_home + "texdoc/texdoc-dist.cnf" }
    let(:home_texdoc_cnf) { texmf_home + "texdoc/texdoc.cnf" }

    # message
    let(:recommended_files) do
      <<~EXPECTED
        Recommended file(s) for personal settings:
            #{home_texdoc_cnf}
      EXPECTED
    end

    context "with normal setting" do
      before(:each) { set_environment_variable "TEXMFDIST", texmf_dist.to_s }
      before(:each) { run_texdoc "-f" }

      it "should contain version information" do
        expect(stdout).to include("#{texdoclib} #{version}")
      end

      it "should contain active files" do
        expect(stdout).to include("active\t#{home_texdoc_cnf}")
        expect(stdout).to include("active\t#{home_texdoc_dist_cnf}")
      end

      it "should contain disabled files" do
        expect(stdout).to include("disabled\t#{dist_texdoc_cnf}")
      end

      it "should not contain not found files" do
        expect(stdout).not_to include("not found\t#{dist_texdoc_dist_cnf}")
      end

      it "should contain recommended setting file locations" do
        expect(stdout).to include(recommended_files)
      end
    end

    context "with verbose setting" do
      before(:each) { set_environment_variable "TEXMFDIST", texmf_dist.to_s }
      before(:each) { run_texdoc "-fv" }

      it "should contain version information" do
        expect(stdout).to include("#{texdoclib} #{version}")
      end

      it "should contain active files" do
        expect(stdout).to include("active\t#{home_texdoc_cnf}")
        expect(stdout).to include("active\t#{home_texdoc_dist_cnf}")
      end

      it "should contain disabled files" do
        expect(stdout).to include("disabled\t#{dist_texdoc_cnf}")
      end

      it "should not contain not found files" do
        expect(stdout).to include("not found\t#{dist_texdoc_dist_cnf}")
      end

      it "should contain recommended setting file locations" do
        expect(stdout).to include(recommended_files)
      end
    end
  end
end
