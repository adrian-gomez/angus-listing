require 'spec_helper'

require 'angus/listing/conditions'
require 'angus/listing/conditions/or_condition'
require 'angus/listing/conditions/true_condition'

describe Angus::Listing::Conditions::OrCondition do
  describe '.operator' do
    it 'is :or' do
      operator = Angus::Listing::Conditions::OrCondition.operator

      expect(operator).to eq(:or)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that ORs some SQL conditions' do
      condition = Angus::Listing::Conditions::OrCondition.new(:true, :true)

      true_condition = Angus::Listing::Conditions::TrueCondition.new
      allow(Angus::Listing::Conditions).to receive(:build_condition).and_return(true_condition)

      expect(condition.to_sql).to match(/\sOR\s/)
    end

    describe 'when only one condition' do
      it 'does not adds an OR' do
        condition = Angus::Listing::Conditions::OrCondition.new(:true)

        true_condition = Angus::Listing::Conditions::TrueCondition.new
        allow(Angus::Listing::Conditions).to receive(:build_condition).and_return(true_condition)

        expect(condition.to_sql).to eq("(#{true_condition.to_sql})")
      end
    end
  end
end
