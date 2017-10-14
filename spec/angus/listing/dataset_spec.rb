require 'spec_helper'

require 'active_record'
require 'angus/listing/dataset'

module Specs
  module Angus
    module Listing

      class CreateFoosMigration < ActiveRecord::Migration
        def up
          create_table(:foos) do |t|
            t.column :amount, :integer
            t.column :card_number, :string
            t.column :quotas, :integer
            t.column :code, :integer
          end
        end

        def down
          drop_table(:foos)
        end
      end

      class Foo < ActiveRecord::Base
      end

    end
  end
end

describe Angus::Listing::DataSet do
  def ar_configuration_name
    :angus_listing_test
  end

  def ar_adapter
    if RUBY_ENGINE == 'jruby'
      'jdbcsqlite3'
    else
      'sqlite3'
    end
  end

  before(:all) do
    ActiveRecord::Base.configurations[ar_configuration_name.to_s] = {
      :adapter => ar_adapter,
      :database => ':memory:',
    }

    Specs::Angus::Listing::Foo.establish_connection ar_configuration_name


    migration = Specs::Angus::Listing::CreateFoosMigration.new

    migration.instance_exec(Specs::Angus::Listing::Foo.connection) do |conn|
      @connection = conn
    end

    migration.up
  end

  around(:each) do |example|
    Specs::Angus::Listing::Foo.connection.transaction do
      example.run
      raise ActiveRecord::Rollback, 'Rollback the changes made during the example.'
    end
  end

  after(:all) do
    ActiveRecord::Base.configurations.delete(ar_configuration_name)
  end

  let(:ds_class) do
    Class.new(Angus::Listing::DataSet) do
      column :amount
      column :card_number
      column :quotas
      column :code

      aggregate :total_amount, [:sum, :amount]

      def relation
        Specs::Angus::Listing::Foo
      end
    end
  end

  describe '#calculations' do

    let(:ds) { ds_class.new }

    it 'makes the required calculations' do
      Specs::Angus::Listing::Foo.create(:amount => 10)
      Specs::Angus::Listing::Foo.create(:amount => 10)

      expect(ds.calculations).to include(:total_amount => 20)
    end

    context 'when grouping' do
      let(:ds_class) do
        Class.new(Angus::Listing::DataSet) do
          column :amount
          column :quotas

          aggregate :total_amount, [:sum, :amount], [:quotas]

          def relation
            Specs::Angus::Listing::Foo
          end
        end
      end

      let(:ds) { ds_class.new }

      it 'groups by quotas' do
        Specs::Angus::Listing::Foo.create(:amount => 10, :quotas => 1)

        Specs::Angus::Listing::Foo.create(:amount => 20, :quotas => 2)
        Specs::Angus::Listing::Foo.create(:amount => 30, :quotas => 2)


        expect(ds.calculations).to include(:total_amount)

        expect(ds.calculations[:total_amount]).to include(1 => 10)
        expect(ds.calculations[:total_amount]).to include(2 => 50)
      end
    end

    context 'when no aggregations defined' do

      let(:ds_class) do
        Class.new(Angus::Listing::DataSet) do

          column :amount

          def relation
            Specs::Angus::Listing::Foo
          end
        end
      end

      it 'is empty' do
        expect(ds.calculations).to be_empty
      end

    end
  end

  describe '#filter_includes_values' do

    subject(:ds) { ds_class.new }

    let(:affected_tables) { [:brands, :devices] }

    context 'when the includes values are just an array' do
      let(:includes_values) { [:device, :commerce_branch] }

      it 'returns only includes for the affected tabled' do
        expect(ds.filter_includes_values(includes_values, affected_tables)).to eq([:device])
      end
    end

    context 'when the includes values contains a hash' do
      let(:includes_values) { [:device, :commerce_branch, {:product=>[:brand]}] }

      context 'and just the hash key is affected' do
        let(:affected_tables) { [:products, :devices] }

        it 'returns just the hash key in the includes values' do
          expect(ds.filter_includes_values(includes_values, affected_tables)).to eq([:device, :product])
        end
      end

      context 'and any of the hash values are affected' do
        let(:affected_tables) { [:brands, :devices] }

        it 'returns the complete hash in the includes values' do
          expect(ds.filter_includes_values(includes_values,
                                           affected_tables)).to eq([:device, {:product=>[:brand]}])
        end
      end
    end

  end

  describe '#list' do

    context 'without Q' do
      let(:count) { 5 }

      before do
        1.upto(count) do |i|
          Specs::Angus::Listing::Foo.create(:code => i)
        end
      end

      it 'returns all the existing records' do
        ds = ds_class.new

        list = ds.list

        expect(list.length).to eq(count)
      end
    end

    context 'with paging' do
      let(:count) { 10 }

      let(:ds) do
        ds_class.new(
          :paging => {:page => 2, :per_page => 3}
        )
      end

      before do
        1.upto(count) do |i|
          Specs::Angus::Listing::Foo.create(:code => i)
        end
      end

      it 'returns the required results count' do
        list = ds.list

        expect(list.length).to eq(3)
      end

      it 'returns the required page' do
        list = ds.list

        expect(list[0].code).to eq(4)
        expect(list[1].code).to eq(5)
        expect(list[2].code).to eq(6)
      end
    end

    context 'with sorting' do
      before do
        Specs::Angus::Listing::Foo.create(:amount => 20, :card_number => 'c', :quotas => 2, :code => 1)
        Specs::Angus::Listing::Foo.create(:amount => 20, :card_number => 'c', :quotas => 3, :code => 2)
        Specs::Angus::Listing::Foo.create(:amount => 10, :card_number => 'b', :quotas => 2, :code => 3)
        Specs::Angus::Listing::Foo.create(:amount => 30, :card_number => 'b', :quotas => 1, :code => 4)
        Specs::Angus::Listing::Foo.create(:amount => 30, :card_number => 'a', :quotas => 1, :code => 5)
      end

      it 'sorts in the specified order' do
        ds = ds_class.new(:sorting => [:card_number, :asc])

        list = ds.list

        card_numbers = list.map(&:card_number)

        expect(card_numbers).to eq(['a', 'b', 'b', 'c', 'c'])
      end

      it 'supports multiple sort options' do
        ds = ds_class.new(:sorting => [:card_number, :amount, :asc])

        list = ds.list

        card_numbers = list.map(&:card_number)
        amounts = list.map(&:amount)

        expect(card_numbers).to eq(['a', 'b', 'b', 'c', 'c'])

        expect(amounts).to eq([30, 10, 30, 20, 20])
      end

      it 'supports mixed sorting' do
        ds = ds_class.new(:sorting => [:card_number, :asc, :quotas, :desc])

        list = ds.list

        card_numbers = list.map(&:card_number)
        quotas = list.map(&:quotas)

        expect(card_numbers).to eq(['a', 'b', 'b', 'c', 'c'])

        expect(quotas).to eq([1, 2, 1, 3, 2])
      end

      context 'when sorting by an unknown column' do
        it 'raises a NameError with the invalid column name' do
          expect {
            ds_class.new(:sorting => [:unknown_column])
          }.to raise_error(NameError, /unknown_column/)
        end
      end
    end

    context 'with filtering' do
      it 'filters by the given operand' do
        Specs::Angus::Listing::Foo.create(:amount => 20, :card_number => 'c', :quotas => 2, :code => 1)

        ds = ds_class.new(
          :filter => [:eq, :amount, '?'],
          :values => [20]
        )

        list = ds.list


        expect(list).to_not be_empty

        expect(list[0].amount).to eq(20)
      end

      context 'when filtering by an unknown column' do
        it 'raises a NameError with the invalid column name' do
          expect {
            ds_class.new(:filter => [:eq, :unknown_column, '?'])
          }.to raise_error(NameError, /unknown_column/)
        end
      end
    end
  end

  describe '#filter_options' do
    let(:options) { [:and, [:eq, :quotas, '?'], [:not, [:in, :amount, '?', '?', '?']]] }

    it 'returns the filter options' do
      ds = ds_class.new(:filter => options)

      expect(ds.filter_options).to be(options)
    end
  end

  describe '#report' do
    it 'returns a report' do
      ds = ds_class.new

      report = ds.report

      expect(report).to be_a(Angus::Listing::Report)
    end
  end

  describe '#sorting_options' do
    let(:options) { [:card_number, :asc, :quotas, :desc] }

    it 'returns the sorting options' do
      ds = ds_class.new(:sorting => options)

      expect(ds.sorting_options).to eq(options)
    end
  end

  describe '#paging_options' do
    let(:options) { {:page => 2, :per_page => 3} }

    it 'returns the paging options' do
      ds = ds_class.new(:paging => options)

      expect(ds.paging_options).to eq(options)
    end
  end

  describe '#filter_options' do
    let(:options) { [:in, :amount, '?', '?', '?'] }

    it 'returns the filter options' do
      ds = ds_class.new(:filter => options)

      expect(ds.filter_options).to eq(options)
    end
  end
end
