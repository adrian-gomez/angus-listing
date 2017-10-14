require 'spec_helper'

require 'angus/listing/conditions/greater_than_or_equal_condition'

describe Angus::Listing::Conditions::GreaterThanOrEqualCondition do
  describe '.operator' do
    it 'is :gte' do
      operator = Angus::Listing::Conditions::GreaterThanOrEqualCondition.operator

      expect(operator).to eq(:gte)
    end
  end

  describe '#to_sql' do
    it 'returns an greater than equal condition' do
      condition = Angus::Listing::Conditions::GreaterThanOrEqualCondition.new('id', 1)
      sql = 'id >= 1'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
