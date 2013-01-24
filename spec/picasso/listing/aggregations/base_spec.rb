require 'spec_helper'

require 'picasso/listing/aggregations/base'

describe Picasso::Listing::Aggregations::Base do

  describe '#sql_group_by' do
    context 'when grouping' do
      it 'returns the columns for a GROUP BY clause' do
        aggregation = Picasso::Listing::Aggregations::Base.new(:total, :amount, [:quotas, :kind])

        aggregation.sql_group_by.should eq('quotas, kind')
      end
    end

    context 'when no grouping' do
      it 'is an empty string' do
        aggregation = Picasso::Listing::Aggregations::Base.new(:total, :amount)

        aggregation.sql_group_by.should eq('')
      end
    end
  end

  describe '#group_for' do

    let(:aggregation) do
      Picasso::Listing::Aggregations::Base.new(:total, :amount, grouping)
    end

    let(:record) do
      {:population => 3000, :country => 'US', :city => 'NEVADA'}
    end

    context 'when grouping by more than one column' do
      let(:grouping) do
        [:country, :city]
      end

      it 'returns the group as an array' do
        group = aggregation.group_for(record)

        group.should eq(['US', 'NEVADA'])
      end
    end

    context 'when grouping by one column' do
      let(:grouping) do
        [:country]
      end

      it 'returns the group' do
        group = aggregation.group_for(record)

        group.should eq('US')
      end
    end

    context 'when no grouping' do
      let(:grouping) do
        []
      end

      it 'returns the group' do
        group = aggregation.group_for(record)

        group.should be_nil
      end
    end
  end

  describe '#extract_from' do

    let(:aggregation) do
      Picasso::Listing::Aggregations::Base.new(:total_population, :population, grouping)
    end

    let(:relation) do
      [
        {:total_population => 3000, :country => 'US', :city => 'NEVADA'},
        {:total_population => 7000, :country => 'US', :city => 'NEW YORK'},
      ]
    end

    context 'when grouping' do
      let(:grouping) do
        [:country, :city]
      end

      it 'extracts the calculations for each group' do
        result = aggregation.extract_from(relation)

        result.should include(['US', 'NEVADA'])
        result.should include(['US', 'NEW YORK'])

        result[['US', 'NEVADA']].should eq(3000)
        result[['US', 'NEW YORK']].should eq(7000)
      end
    end
  end

end
