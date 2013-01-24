require 'spec_helper'

require 'picasso/listing/report'

describe Picasso::Listing::Report do

  describe 'accessors' do
    subject { Picasso::Listing::Report.new(:q, :list, :calculations, :count) }

    its(:q) { should eq(:q) }

    its(:list) { should eq(:list) }

    its(:calculations) { should eq(:calculations) }

    its(:count) { should eq(:count) }
  end

  describe '#page_count' do
    it 'returns the total pages count' do
      count = 12
      q = {:paging => { :per_page => 5 }}

      report = Picasso::Listing::Report.new(q, :list, :calculations, count)

      report.page_count.should eq(3)
    end
  end
end
