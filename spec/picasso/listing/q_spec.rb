require 'spec_helper'

require 'picasso/listing/q'

describe Picasso::Listing::Q do

  let(:q_options) do
    {
      :filter => [:true],
      :paging => {:page => 1, :per_page => 10},
      :sorting => [:id, :asc],
      :values => [true],
    }
  end

  let(:columns) { [:id] }

  describe 'accessors' do
    subject { Picasso::Listing::Q.new(q_options, columns) }

    its(:filter) { should be_a(Picasso::Listing::QFilter) }

    its(:paging) { should be_a(Picasso::Listing::QPaging) }

    its(:sorting) { should be_a(Picasso::Listing::QSorting) }
  end

  describe '.new' do
    it 'raises an error when an invalid filter is passed in' do
      expect {
        Picasso::Listing::Q.new({:filter => [:unknown]})
      }.to raise_error
    end

    it 'raises an error when an invalid sorting is passed in' do
      expect {
        Picasso::Listing::Q.new({:sorting => [:unknown]})
      }.to raise_error
    end
  end

  describe '#options' do
    it 'returns the options which builds the same Q' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.options.should eq(q_options)
    end
  end

  describe '#filter_options' do
    it 'returns the filter options' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.filter_options.should eq(q_options[:filter])
    end
  end

  describe '#paging_options' do
    it 'returns the paging options' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.paging_options.should eq(q_options[:paging])
    end
  end

  describe '#sorting_options' do
    it 'returns the sorting options' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.sorting_options.should eq(q_options[:sorting])
    end
  end

  describe '#values' do
    it 'returns the values for the Q object' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.values.should eq(q_options[:values])
    end
  end
end

describe Picasso::Listing::QFilter do

  let (:options) { [:true] }
  let (:columns) { [:id ] }

  describe '#options' do
    it 'returns the options for instantiating the same QFilter' do
      q_filter = Picasso::Listing::QFilter.new(options, columns)

      q_filter.options.should eq(options)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL string according to the current filter' do
      q_filter = Picasso::Listing::QFilter.new(options, columns)

      q_filter.to_sql.should eq('1 = 1')
    end
  end

  describe '#validate!' do
    it 'is true when the current filter is a valid one' do
      q_filter = Picasso::Listing::QFilter.new(options, columns)

      q_filter.validate!.should be
    end

    it 'raises an error when the current filter is not a valid one' do
      options = [:eq, :unknown_column, '?']
      q_filter = Picasso::Listing::QFilter.new(options, columns)

      expect {
        q_filter.validate!
      }.to raise_error(NameError)
    end
  end
end

describe Picasso::Listing::QPaging do
  let (:options) do
    { :per_page => 15, :page => 3 }
  end

  describe '#options' do
    it 'returns the options for instantiating the same QFilter' do
      q_paging = Picasso::Listing::QPaging.new(options)

      q_paging.options.should eq(options)
    end
  end

  describe '#offset' do
    it 'returns the offset for the current page' do
      q_paging = Picasso::Listing::QPaging.new(options)

      q_paging.offset.should eq(30)
    end
  end

  context 'with empty options' do
    it 'uses default options' do
      q_paging = Picasso::Listing::QPaging.new({})
      q_options = q_paging.options

      q_options.should include(:page => Picasso::Listing::QPaging::DEFAULT_PAGE)
      q_options.should include(:per_page => Picasso::Listing::QPaging::DEFAULT_PER_PAGE)
    end
  end

  context 'when page = 0' do
    it 'uses page = 1' do
      q_paging = Picasso::Listing::QPaging.new({:page => 0})
      q_options = q_paging.options

      q_options.should include(:page => 1)
    end
  end
end

describe Picasso::Listing::QSorting do
  describe '.sort_direction?' do
    it 'is true when :asc' do
      result = Picasso::Listing::QSorting.sort_direction?(:asc)

      result.should be
    end

    it 'is true when :desc' do
      result = Picasso::Listing::QSorting.sort_direction?(:desc)

      result.should be
    end

    it 'is false when anything else' do
      result = Picasso::Listing::QSorting.sort_direction?(:anything_else)

      result.should be_false
    end
  end

  describe '#options' do
    let(:columns) { [:id] }
    let(:options) { [:id, :asc] }

    it 'returns the options for instantiating the same QFilter' do
      q_sorting = Picasso::Listing::QSorting.new(options, columns)

      q_sorting.options.should eq(options)
    end
  end

  describe '#valid_sorting_sequence?' do
    let(:columns) { [:id] }

    it 'is true when valid' do
      q_sorting = Picasso::Listing::QSorting.new([:id, :description, :asc, :amount, :desc], columns)

      q_sorting.should be_valid_sorting_sequence
    end

    it 'is false when the first item is a sorting direction' do
      q_sorting = Picasso::Listing::QSorting.new([:desc, :id, :description, :asc, :amount, :desc], columns)

      q_sorting.should_not be_valid_sorting_sequence
    end

    it 'is false when the there are two consecutive sorting directions' do
      q_sorting = Picasso::Listing::QSorting.new([:id, :description, :asc, :desc, :amount, :desc], columns)

      q_sorting.should_not be_valid_sorting_sequence
    end
  end

  describe '#to_sql' do
    let(:columns) { [:id, :description, :amount] }
    let(:options) { [:id, :description, :asc, :amount, :desc] }

    it 'returns a sorting condition' do
      q_sorting = Picasso::Listing::QSorting.new(options, columns)
      sql = '`id`, `description` ASC, `amount` DESC'

      q_sorting.to_sql.should eq(sql)
    end
  end
end
