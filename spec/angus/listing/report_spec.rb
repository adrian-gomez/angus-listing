require 'spec_helper'

require 'angus/listing/report'

describe Angus::Listing::Report do

  describe 'accessors' do
    subject { Angus::Listing::Report.new(:q, :list, :calculations, :count) }

    its(:q) { should eq(:q) }

    its(:list) { should eq(:list) }

    its(:calculations) { should eq(:calculations) }

    its(:count) { should eq(:count) }
  end

  describe '#page_count' do
    let(:count) { 12 }

    let(:q) do
      { :paging => { :per_page => 5 } }
    end

    it 'returns the total pages count' do
      report = Angus::Listing::Report.new(q, :list, :calculations, count)

      expect(report.page_count).to eq(3)
    end

    context 'when count is nil' do
      let(:count) { nil }

      it 'returns nil' do
        report = Angus::Listing::Report.new(q, :list, :calculations, count)

        expect(report.page_count).to be_nil
      end
    end
  end
end
