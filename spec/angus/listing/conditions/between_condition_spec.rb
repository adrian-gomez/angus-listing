require 'spec_helper'

require 'angus/listing/conditions/between_condition'

describe Angus::Listing::Conditions::BetweenCondition do
  describe '.operator' do
    it 'is :between' do
      operator = Angus::Listing::Conditions::BetweenCondition.operator

      expect(operator).to eq(:between)
    end
  end

  describe '#to_sql' do
    it 'returns an BETWEEN condition' do
      condition = Angus::Listing::Conditions::BetweenCondition.new('id', 1, 2)
      sql = 'id BETWEEN 1 AND 2'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
