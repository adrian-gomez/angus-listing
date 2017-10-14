require 'spec_helper'

require 'angus/listing/conditions'
require 'angus/listing/conditions/not_condition'
require 'angus/listing/conditions/true_condition'

describe Angus::Listing::Conditions::NotCondition do
  describe '.operator' do
    it 'is :not' do
      operator = Angus::Listing::Conditions::NotCondition.operator

      expect(operator).to eq(:not)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that negates another SQL condition' do
      condition = Angus::Listing::Conditions::NotCondition.new(:another)

      another_condition = Angus::Listing::Conditions::TrueCondition.new
      allow(Angus::Listing::Conditions).to receive(:build_condition).and_return(another_condition)

      expect(condition.to_sql).to match(/^NOT\s/)
    end
  end
end
