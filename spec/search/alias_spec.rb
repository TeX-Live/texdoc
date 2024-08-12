require 'spec_helper'
require 'digest/md5'

RSpec.describe "Alias", :type => :aruba do
  include_context "messages"
  include_context "texmf"

  let(:test_texdoc_cnf) { texmf_home / "texdoc/texdoc.cnf" }

  context "is set in texdoc.cnf" do
    let(:config_content) {
      <<~EOF
        alias testalias = texlive
      EOF
    }
    before(:each) { File.write(test_texdoc_cnf, config_content) }

    let(:test_res_name) { "texlive/texlive-en/texlive-en.pdf" }
    let(:test_res_hash) { Digest::MD5.hexdigest(test_res_name)[0, 7] }
    let(:test_res_realpath) { Regexp.escape(normalize_path(test_res_name)) }

    context "and query the exact alias" do
      let(:test_query) { "testalias" }
      before(:each) { run_texdoc "-ddocfile", test_query }

      it "should find aliased documents" do
        expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
        expect(stderr).to match(/#{debug_line "search"} \(#{test_res_hash}\) File \S*#{test_res_realpath} found/)
        expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
        expect(stderr).to include(debug_line "docfile", "(#{test_res_hash}) matches: texlive (alias)")
        expect(last_command_started).to be_successfully_executed
      end
    end

    context "and query a misspelled alias" do
      let(:test_query) { "testaliases" }
      before(:each) { run_texdoc "-M", "-ddocfile", test_query }

      it "should not find aliased documents" do
        expect(stderr).to include(debug_line "search", "Searching documents for pattern \"#{test_query}\"")
        expect(stderr).not_to match(/#{debug_line "search"} \(#{test_res_hash}\) File \S*#{test_res_realpath} found/)
        expect(stderr).not_to include(debug_line "docfile", "(#{test_res_hash}) name: #{test_res_name}")
        expect(stderr).not_to include(debug_line "docfile", "(#{test_res_hash}) matches: texlive (alias)")
      end
    end
  end
end
