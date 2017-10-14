require 'spec_helper'

require 'angus/listing/aggregations'

describe Angus::Listing::Aggregations::SumAggregation do
  describe '.function' do
    it 'is :sum' do
      function = Angus::Listing::Aggregations::SumAggregation.function

      expect(function).to eq(:sum)
    end
  end

  describe '#default' do
    it 'is 0' do
      aggregation = Angus::Listing::Aggregations::SumAggregation.new(:alias, :column)

      expect(aggregation.default).to eq('0')
    end
  end

  describe '#sql_select' do
    it 'returns a SQL condition that sums up by a given column' do
      aggregation = Angus::Listing::Aggregations::SumAggregation.new(:alias, :column)

      expect(aggregation.sql_select).to match(/SUM\(column\)/)
    end

    it 'specifies a SQL alias' do
      aggregation = Angus::Listing::Aggregations::SumAggregation.new(:alias, :column)

      expect(aggregation.sql_select).to match(/AS alias/)
    end
  end
end
