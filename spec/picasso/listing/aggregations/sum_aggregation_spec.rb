require 'spec_helper'

require 'picasso/listing/aggregations'

describe Picasso::Listing::Aggregations::SumAggregation do

  describe '.function' do
    it 'is :sum' do
      function = Picasso::Listing::Aggregations::SumAggregation.function

      function.should eq(:sum)
    end
  end

  describe '#default' do
    it 'is 0' do
      aggregation = Picasso::Listing::Aggregations::SumAggregation.new(:alias, :column)

      aggregation.default.should eq('0')
    end
  end

  describe '#sql_select' do
    it 'returns a SQL condition that sums up by a given column' do
      aggregation = Picasso::Listing::Aggregations::SumAggregation.new(:alias, :column)

      aggregation.sql_select.should match(/SUM\(column\)/)
    end

    it 'specifies a SQL alias' do
      aggregation = Picasso::Listing::Aggregations::SumAggregation.new(:alias, :column)

      aggregation.sql_select.should match(/AS alias/)
    end
  end
end
