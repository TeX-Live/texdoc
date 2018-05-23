require 'spec_helper'

RSpec.describe 'Integrate Aruba into RSpec', :type => :aruba do
  context 'when to be or not be...' do
    it { expect(aruba).to be }
  end

  context 'when write file' do
    let(:file) { 'file.txt' }

    before(:each) { write_file file, 'Hello World' }

    it { expect(file).to be_an_existing_file }
    it { expect([file]).to include an_existing_file }
  end
end
