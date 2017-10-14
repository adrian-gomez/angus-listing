require 'spec_helper'

require 'angus/listing/conditions/equal_condition'

describe Angus::Listing::Conditions::EqualCondition do
  describe '.operator' do
    it 'is :eq' do
      operator = Angus::Listing::Conditions::EqualCondition.operator

      expect(operator).to eq(:eq)
    end
  end

  describe '#to_sql' do
    it 'returns an equal condition' do
      condition = Angus::Listing::Conditions::EqualCondition.new('id', 1)
      sql = 'id = 1'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
