require 'aruba/rspec'
require 'pathname'

RSpec.shared_context "environment" do
  texlua = 'texlua'
  texdoc = Pathname.pwd.join('script/texdoc.tlu').to_s
  let(:cmd) { texlua + ' ' + texdoc }
end
