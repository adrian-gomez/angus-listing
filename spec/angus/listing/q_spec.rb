require 'spec_helper'

require 'angus/listing/q'

describe Angus::Listing::Q do

  let(:q_options) do
    {
      :filter => [:true],
      :paging => {:page => 1, :per_page => 10},
      :select => [:list],
      :sorting => [:id, :asc],
      :values => [true],
    }
  end

  let(:columns) { { id: nil } }

  describe 'accessors' do
    subject { Angus::Listing::Q.new(q_options, columns) }

    its(:filter) { should be_a(Angus::Listing::QFilter) }

    its(:paging) { should be_a(Angus::Listing::QPaging) }

    its(:sorting) { should be_a(Angus::Listing::QSorting) }
  end

  describe '.new' do
    it 'raises an error when an invalid filter is passed in' do
      expect {
        Angus::Listing::Q.new({:filter => [:unknown]})
      }.to raise_error(NameError, 'unknown operator unknown')
    end

    it 'raises an error when an invalid sorting is passed in' do
      expect {
        Angus::Listing::Q.new({:sorting => [:unknown]})
      }.to raise_error(NameError, 'invalid direction(s) or column name(s): unknown')
    end
  end

  describe '#options' do
    it 'returns the options which builds the same Q' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.options).to eq(q_options)
    end
  end

  describe '#filter_options' do
    it 'returns the filter options' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.filter_options).to eq(q_options[:filter])
    end
  end

  describe '#paging_options' do
    it 'returns the paging options' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.paging_options).to eq(q_options[:paging])
    end
  end

  describe '#select_options' do
    it 'returns the select options' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.select_options).to eq(q_options[:select])
    end
  end

  describe '#sorting_options' do
    it 'returns the sorting options' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.sorting_options).to eq(q_options[:sorting])
    end
  end

  describe '#values' do
    it 'returns the values for the Q object' do
      q = Angus::Listing::Q.new(q_options, columns)

      expect(q.values).to eq(q_options[:values])
    end
  end
end

describe Angus::Listing::QFilter do

  let(:options) { [:true] }
  let(:columns) { { id: nil, :'transactions.product_code' => nil } }
  let(:ns) { 'ns' }

  describe '#affected_tables' do

    let(:options) { ['and', ['eq', 'card_brands.name', '?'], ['eq', 'ticket_number', '?']] }

    context 'when the columns used in the options are included in the accepted columns' do
      let(:columns) { { id: nil, :'card_brands.name' => nil, ticket_number: nil } }

      it 'returns the affected tables for given options' do
        q_filter = Angus::Listing::QFilter.new(options, columns, ns)

        expect(q_filter.affected_tables).to eq([:card_brands])
      end
    end

    context 'when the columns used in the options are not included in the accepted columns' do
      let(:columns) { { id: nil, ticket_number: nil } }

      it 'does not return the affected tables for given options' do
        q_filter = Angus::Listing::QFilter.new(options, columns, ns)

        expect(q_filter.affected_tables).to eq([])
      end
    end

  end

  describe '#options' do
    it 'returns the options for instantiating the same QFilter' do
      q_filter = Angus::Listing::QFilter.new(options, columns, ns)

      expect(q_filter.options).to eq(options)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL string according to the current filter' do
      q_filter = Angus::Listing::QFilter.new(options, columns, ns)

      expect(q_filter.to_sql).to eq('1 = 1')
    end

    context 'when column is not namespaced' do
      it 'escapes and adds the namespace to the columns' do
        options = [:eq, :id, '?']
        q_filter = Angus::Listing::QFilter.new(options, columns, ns)

        expect(q_filter.to_sql).to match(/`ns`.`id`/)
      end
    end

    context 'when column is namespaced' do
      it 'honours the current namespace' do
        options = [:eq, 'transactions.product_code', '?']
        q_filter = Angus::Listing::QFilter.new(options, columns, ns)

        expect(q_filter.to_sql).to match(/`transactions`.`product_code`/)
      end
    end
  end

  describe '#validate!' do
    it 'is true when the current filter is a valid one' do
      q_filter = Angus::Listing::QFilter.new(options, columns, ns)

      expect(q_filter.validate!).to be
    end

    it 'raises an error when the current filter is not a valid one' do
      options = [:eq, :unknown_column, '?']
      q_filter = Angus::Listing::QFilter.new(options, columns, ns)

      expect {
        q_filter.validate!
      }.to raise_error(NameError)
    end
  end
end

describe Angus::Listing::QPaging do
  let (:options) do
    { :per_page => 15, :page => 3 }
  end

  describe '#options' do
    it 'returns the options for instantiating the same QFilter' do
      q_paging = Angus::Listing::QPaging.new(options)

      expect(q_paging.options).to eq(options)
    end
  end

  describe '#offset' do
    it 'returns the offset for the current page' do
      q_paging = Angus::Listing::QPaging.new(options)

      expect(q_paging.offset).to eq(30)
    end
  end

  context 'with empty options' do
    it 'uses default options' do
      q_paging = Angus::Listing::QPaging.new({})
      q_options = q_paging.options

      expect(q_options).to include(:page => Angus::Listing::QPaging::DEFAULT_PAGE)
      expect(q_options).to include(:per_page => Angus::Listing::QPaging::DEFAULT_PER_PAGE)
    end
  end

  context 'when page = 0' do
    it 'uses page = 1' do
      q_paging = Angus::Listing::QPaging.new({:page => 0})
      q_options = q_paging.options

      expect(q_options).to include(:page => 1)
    end
  end
end

describe Angus::Listing::QSelect do

  describe '#calculation?' do
    subject(:q_select) do
      Angus::Listing::QSelect.new([
        {:calculations => [:total_amount]}
      ])
    end

    context 'when the given calculation is present' do
      it 'is true' do
        expect(q_select.calculation?(:total_amount)).to be
      end
    end

    context 'when the given calculation is not present' do
      it 'is false' do
        expect(q_select.calculation?(:average)).to_not be
      end
    end
  end

  describe '#count?' do
    context 'when count is present' do
      subject do
        Angus::Listing::QSelect.new([:count])
      end

      its(:count?) { should be }
    end

    context 'when count is not present' do
      subject do
        Angus::Listing::QSelect.new([:list])
      end

      its(:count?) { should_not be }
    end

    context 'when no configuration' do
      subject do
        Angus::Listing::QSelect.new([])
      end

      its(:count?) { should be }
    end
  end

  describe '#list?' do
    context 'when list is present' do
      subject do
        Angus::Listing::QSelect.new([:list])
      end

      its(:list?) { should be }
    end

    context 'when list is not present' do
      subject do
        Angus::Listing::QSelect.new([:count])
      end

      its(:list?) { should_not be }
    end

    context 'when no configuration' do
      subject do
        Angus::Listing::QSelect.new([])
      end

      its(:list?) { should be }
    end
  end
end

describe Angus::Listing::QSorting do

  let(:ns) { 'ns' }

  describe '.sort_direction?' do
    it 'is true when :asc' do
      result = Angus::Listing::QSorting.sort_direction?(:asc)

      expect(result).to be
    end

    it 'is true when :desc' do
      result = Angus::Listing::QSorting.sort_direction?(:desc)

      expect(result).to be
    end

    it 'is false when anything else' do
      result = Angus::Listing::QSorting.sort_direction?(:anything_else)

      expect(result).to be(false)
    end
  end

  describe '#options' do
    let(:columns) { { id: nil } }
    let(:options) { [:id, :asc] }

    it 'returns the options for instantiating the same QFilter' do
      q_sorting = Angus::Listing::QSorting.new(options, columns, ns)

      expect(q_sorting.options).to eq(options)
    end
  end

  describe '#valid_sorting_sequence?' do
    let(:columns) { { id: nil } }

    it 'is true when valid' do
      q_sorting = Angus::Listing::QSorting.new([:id, :description, :asc, :amount, :desc], columns, ns)

      expect(q_sorting).to be_valid_sorting_sequence
    end

    it 'is false when the first item is a sorting direction' do
      q_sorting = Angus::Listing::QSorting.new([:desc, :id, :description, :asc, :amount, :desc], columns, ns)

      expect(q_sorting).to_not be_valid_sorting_sequence
    end

    it 'is false when the there are two consecutive sorting directions' do
      q_sorting = Angus::Listing::QSorting.new([:id, :description, :asc, :desc, :amount, :desc], columns, ns)

      expect(q_sorting).to_not be_valid_sorting_sequence
    end
  end

  describe '#to_sql' do
    let(:columns) { { id: nil, description: nil, amount: nil, :'transactions.product_code' => nil} }
    let(:options) { [:id, :description, :asc, :amount, :desc] }

    it 'returns a sorting condition' do
      q_sorting = Angus::Listing::QSorting.new(options, columns, ns)
      sql = '`ns`.`id`, `ns`.`description` ASC, `ns`.`amount` DESC'

      expect(q_sorting.to_sql).to eq(sql)
    end

    context 'when column is namespaced' do
      let(:options) { ['transactions.product_code', :asc] }

      it 'honours the current namespace' do
        q_sorting = Angus::Listing::QSorting.new(options, columns, ns)
        sql = '`transactions`.`product_code` ASC'

        expect(q_sorting.to_sql).to eq(sql)
      end
    end
  end
end
