require 'spec_helper'

require 'picasso/listing/utils'

describe Picasso::Listing::Utils do

  subject(:utils) { Picasso::Listing::Utils }

  describe '.add_namespace' do
    let(:ns) { 'ns' }

    context 'when column does not belongs to a namespace' do
      let(:column) { 'product_code' }

      it 'adds the namespace to column' do
        result = utils.add_namespace(column, ns)

        result.should eq('ns.product_code')
      end
    end

    context 'when column already belongs to a namespace' do
      let(:column) { 'transactions.product_code' }

      it 'just retuns the column' do
        result = utils.add_namespace(column, ns)

        result.should eq(column)
      end
    end

  end
end
