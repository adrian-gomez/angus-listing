require 'spec_helper'

require 'picasso/listing/q'

describe Picasso::Listing::Q do

  let(:q_options) do
    {
      :filter => [:true],
      :paging => {:page => 1, :per_page => 10},
      :select => [:list],
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

  describe '#select_options' do
    it 'returns the select options' do
      q = Picasso::Listing::Q.new(q_options, columns)

      q.select_options.should eq(q_options[:select])
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
  let (:columns) { [:id, :'transactions.product_code' ] }
  let(:ns) { 'ns' }

  describe '#options' do
    it 'returns the options for instantiating the same QFilter' do
      q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

      q_filter.options.should eq(options)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL string according to the current filter' do
      q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

      q_filter.to_sql.should eq('1 = 1')
    end

    context 'when column is not namespaced' do
      it 'escapes and adds the namespace to the columns' do
        options = [:eq, :id, '?']
        q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

        q_filter.to_sql.should match(/`ns`.`id`/)
      end
    end

    context 'when column is namespaced' do
      it 'honours the current namespace' do
        options = [:eq, 'transactions.product_code', '?']
        q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

        q_filter.to_sql.should match(/`transactions`.`product_code`/)
      end
    end
  end

  describe '#validate!' do
    it 'is true when the current filter is a valid one' do
      q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

      q_filter.validate!.should be
    end

    it 'raises an error when the current filter is not a valid one' do
      options = [:eq, :unknown_column, '?']
      q_filter = Picasso::Listing::QFilter.new(options, columns, ns)

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

describe Picasso::Listing::QSelect do

  describe '#calculation?' do
    subject(:q_select) do
      Picasso::Listing::QSelect.new([
        {:calculations => [:total_amount]}
      ])
    end

    context 'when the given calculation is present' do
      it 'is true' do
        q_select.calculation?(:total_amount).should be
      end
    end

    context 'when the given calculation is not present' do
      it 'is false' do
        q_select.calculation?(:average).should_not be
      end
    end
  end

  describe '#count?' do
    context 'when count is present' do
      subject do
        Picasso::Listing::QSelect.new([:count])
      end

      its(:count?) { should be }
    end

    context 'when count is not present' do
      subject do
        Picasso::Listing::QSelect.new([:list])
      end

      its(:count?) { should_not be }
    end

    context 'when no configuration' do
      subject do
        Picasso::Listing::QSelect.new([])
      end

      its(:count?) { should be }
    end
  end

  describe '#list?' do
    context 'when list is present' do
      subject do
        Picasso::Listing::QSelect.new([:list])
      end

      its(:list?) { should be }
    end

    context 'when list is not present' do
      subject do
        Picasso::Listing::QSelect.new([:count])
      end

      its(:list?) { should_not be }
    end

    context 'when no configuration' do
      subject do
        Picasso::Listing::QSelect.new([])
      end

      its(:list?) { should be }
    end
  end
end

describe Picasso::Listing::QSorting do

  let(:ns) { 'ns' }

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
      q_sorting = Picasso::Listing::QSorting.new(options, columns, ns)

      q_sorting.options.should eq(options)
    end
  end

  describe '#valid_sorting_sequence?' do
    let(:columns) { [:id] }

    it 'is true when valid' do
      q_sorting = Picasso::Listing::QSorting.new([:id, :description, :asc, :amount, :desc], columns, ns)

      q_sorting.should be_valid_sorting_sequence
    end

    it 'is false when the first item is a sorting direction' do
      q_sorting = Picasso::Listing::QSorting.new([:desc, :id, :description, :asc, :amount, :desc], columns, ns)

      q_sorting.should_not be_valid_sorting_sequence
    end

    it 'is false when the there are two consecutive sorting directions' do
      q_sorting = Picasso::Listing::QSorting.new([:id, :description, :asc, :desc, :amount, :desc], columns, ns)

      q_sorting.should_not be_valid_sorting_sequence
    end
  end

  describe '#to_sql' do
    let(:columns) { [:id, :description, :amount, :'transactions.product_code'] }
    let(:options) { [:id, :description, :asc, :amount, :desc] }

    it 'returns a sorting condition' do
      q_sorting = Picasso::Listing::QSorting.new(options, columns, ns)
      sql = "`ns`.`id`, `ns`.`description` ASC, `ns`.`amount` DESC"

      q_sorting.to_sql.should eq(sql)
    end

    context 'when column is namespaced' do
      let(:options) { ['transactions.product_code', :asc] }

      it 'honours the current namespace' do
        q_sorting = Picasso::Listing::QSorting.new(options, columns, ns)
        sql = "`transactions`.`product_code` ASC"

        q_sorting.to_sql.should eq(sql)
      end
    end
  end
end
