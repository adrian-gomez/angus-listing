require 'spec_helper'

require 'angus/listing/conditions'
require 'angus/listing/conditions/and_condition'
require 'angus/listing/conditions/true_condition'

describe Angus::Listing::Conditions::AndCondition do
  describe '.operator' do
    it 'is :and' do
      operator = Angus::Listing::Conditions::AndCondition.operator

      expect(operator).to eq(:and)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that ANDs some SQL conditions' do
      condition = Angus::Listing::Conditions::AndCondition.new(:true, :true)

      true_condition = Angus::Listing::Conditions::TrueCondition.new
      allow(Angus::Listing::Conditions).to receive(:build_condition).and_return(true_condition)

      expect(condition.to_sql).to match(/\sAND\s/)
    end

    context 'when only one condition' do
      it 'does not adds an AND' do
        condition = Angus::Listing::Conditions::AndCondition.new(:true)

        true_condition = Angus::Listing::Conditions::TrueCondition.new
        allow(Angus::Listing::Conditions).to receive(:build_condition).and_return(true_condition)

        expect(condition.to_sql).to eq("(#{true_condition.to_sql})")
      end
    end
  end
end
