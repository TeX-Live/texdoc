require 'spec_helper'

RSpec.describe "Scoring", :type => :aruba do
  include_context "messages"

  context 'Example query "babel"' do
    let(:test_query) { "babel" }

    context "babel/babel.pdf" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (b26f92e) Name used: latex/babel/babel.pdf
          texdoc debug-score: (b26f92e) Start heuristic scoring with pattern: babel
          texdoc debug-score: (b26f92e) New heuristic score: 4.0. Reason: exact match
          texdoc debug-score: (b26f92e) New heuristic score: 5.5. Reason: directory bonus
          texdoc debug-score: (b26f92e) Final heuristic score: 5.5
          texdoc debug-score: (b26f92e) Max pattern score: 5.5
          texdoc debug-score: (b26f92e) Catalogue details bonus: +1.5
          texdoc debug-score: (b26f92e) Final score: 7.0
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", test_query }

      it "should get exact match + directory bonus + catalogue details bonus" do
        expect(stderr).to include(res_score_log)
      end
    end

    context "babel/babel-code.pdf" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (4abb904) Name used: latex/babel/babel-code.pdf
          texdoc debug-score: (4abb904) Start heuristic scoring with pattern: babel
          texdoc debug-score: (4abb904) New heuristic score: 1.0. Reason: subword match
          texdoc debug-score: (4abb904) New heuristic score: 2.5. Reason: directory bonus
          texdoc debug-score: (4abb904) Final heuristic score: 2.5
          texdoc debug-score: (4abb904) Max pattern score: 2.5
          texdoc debug-score: (4abb904) Catalogue details bonus: +1.5
          texdoc debug-score: (4abb904) Final score: 4.0
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", test_query }

      it "should get subword match + directory bonus + catalogue details bonus" do
        expect(stderr).to include(res_score_log)
      end
    end

    context "babel/README.md" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (d00421e) Name used: latex/babel/readme.md
          texdoc debug-score: (d00421e) Start heuristic scoring with pattern: babel
          texdoc debug-score: (d00421e) New heuristic score: 1.0. Reason: subword match
          texdoc debug-score: (d00421e) New heuristic score: 0.1. Reason: bad basename
          texdoc debug-score: (d00421e) New heuristic score: 1.6. Reason: directory bonus
          texdoc debug-score: (d00421e) Final heuristic score: 1.6
          texdoc debug-score: (d00421e) Max pattern score: 1.6
          texdoc debug-score: (d00421e) Catalogue "readme" bonus: +0.1
          texdoc debug-score: (d00421e) Adjust by 0.1 from global pattern "readme"
          texdoc debug-score: (d00421e) Final score: 1.8
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", test_query }

      it "should get subword match + bad basename + directory bonus + catalogue readme bonus + adjustment" do
        expect(stderr).to include(res_score_log)
      end
    end
  end

  context 'Example query "texlive"' do
    let(:test_query) { "texlive" }

    context "texlive-en/texlive-en.pdf" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf
          texdoc debug-score: (0da8ec4) Matching alias "texlive-en", score: 10.0
          texdoc debug-score: (0da8ec4) Max pattern score: 10.0
          texdoc debug-score: (0da8ec4) Final score: 10.0
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", test_query }

      it "should get alias match score" do
        expect(stderr).to include(res_score_log)
      end
    end

    context "texlive-en/texlive-en.pdf with lang=en" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (0da8ec4) Name used: texlive/texlive-en/texlive-en.pdf
          texdoc debug-score: (0da8ec4) Matching alias "texlive-en", score: 15.0, (language-based)
          texdoc debug-score: (0da8ec4) Max pattern score: 15.0
          texdoc debug-score: (0da8ec4) Final score: 15.0
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", "-clang=en", test_query }

      it "should get language-based alias match score" do
        expect(stderr).to include(res_score_log)
      end
    end

    context "texlive-en/Makefile" do
      let(:res_score_log) do
        <<~EXPECTED
          texdoc debug-score: (104f55d) Name used: texlive/texlive-en/makefile
          texdoc debug-score: (104f55d) Start heuristic scoring with pattern: texlive
          texdoc debug-score: (104f55d) New heuristic score: 1.0. Reason: subword match
          texdoc debug-score: (104f55d) New heuristic score: 0.1. Reason: bad extension
          texdoc debug-score: (104f55d) New heuristic score: 1.6. Reason: directory bonus
          texdoc debug-score: (104f55d) Final heuristic score: 1.6
          texdoc debug-score: (104f55d) Max pattern score: 1.6
          texdoc debug-score: (104f55d) Adjust by -1000.0 from global pattern "/makefile"
          texdoc debug-score: (104f55d) Final score: -998.4
        EXPECTED
      end

      before(:each) { run_texdoc "-dscore", test_query }

      it "should get a very low score" do
        expect(stderr).to include(res_score_log)
      end
    end
  end
end
