require 'spec_helper'

require 'angus/listing/aggregations'

describe Angus::Listing::Aggregations do
  describe '.build' do
    it 'builds an aggregation' do
      function = Angus::Listing::Aggregations::SumAggregation.function
      options = [function, :column]

      aggregation = Angus::Listing::Aggregations.build(:name, options)

      expect(aggregation).to be_a(Angus::Listing::Aggregations::SumAggregation)
    end

    context 'with unknown function' do
      it 'raises a NameError' do
        function = :unknown

        expect {
          Angus::Listing::Aggregations.build(:name, [function])
        }.to raise_error(NameError)
      end
    end
  end
end
