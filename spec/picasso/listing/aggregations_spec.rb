require 'spec_helper'

require 'picasso/listing/aggregations'

describe Picasso::Listing::Aggregations do

  describe '.build' do
    it 'builds an aggregation' do
      function = Picasso::Listing::Aggregations::SumAggregation.function
      options = [function, :column]

      aggregation = Picasso::Listing::Aggregations.build(:name, options)

      aggregation.should be_a(Picasso::Listing::Aggregations::SumAggregation)
    end

    context 'with unknown function' do
      it 'raises a NameError' do
        function = :unknown

        expect {
          Picasso::Listing::Aggregations.build(:name, [function])
        }.to raise_error(NameError)

      end
    end
  end
end
