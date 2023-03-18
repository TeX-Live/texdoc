require 'spec_helper'

RSpec.describe "Directive adjscore", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  let(:texdoc_cnf) { texmf_home / "texdoc/texdoc.cnf" }

  context "global pattern score adjustment" do
    let(:config_content) {
      <<~EOF
        stopalias texlive-en
        adjscore texlive-en = 7.2
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dscore", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(
        debug_line "score",
          "(0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf")
      expect(stderr).to include(
        debug_line "score",
          '(0da8ec4) Adjust by 7.2 from global pattern "texlive-en"')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "global pattern score adjustment for aliased name" do
    let(:config_content) {
      <<~EOF
        adjscore texlive-en = 7.3
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dscore", "-lI", "texlive-en" }

    it "should be effective" do
      expect(stderr).to include(
        debug_line "score",
          "(0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf")
      expect(stderr).to include(
        debug_line "score",
          '(0da8ec4) Adjust by 7.3 from global pattern "texlive-en"')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "specific pattern score adjustment" do
    let(:config_content) {
      <<~EOF
        adjscore(live) texlive-en = -2
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig,score", "-lI", "live" }

    it "should be effective" do
      expect(stderr).to include(
        debug_line "score",
          "(0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf")
      expect(stderr).to include(
        debug_line "score",
          '(0da8ec4) Adjust by -2.0 from specific pattern "texlive-en"')
      expect(last_command_started).to be_successfully_executed
    end
  end

  context "specific pattern score adjustment for unmatch name" do
    let(:config_content) {
      <<~EOF
        adjscore(live) texlive-en = -2
      EOF
    }

    before(:each) { File.write(texdoc_cnf, config_content) }
    before(:each) { run_texdoc "-dconfig,score", "-lI", "texlive-en" }

    it "should not be effective" do
      expect(stderr).to include(
        debug_line "score",
          "(0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf")
      expect(stderr).not_to include(
        debug_line "score",
          '(0da8ec4) Adjust by -2.0 from specific pattern "texlive-en"')
      expect(last_command_started).to be_successfully_executed
    end
  end
end
