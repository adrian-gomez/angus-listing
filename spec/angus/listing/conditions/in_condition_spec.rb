require 'spec_helper'

require 'angus/listing/conditions/in_condition'

describe Angus::Listing::Conditions::InCondition do
  describe '.operator' do
    it 'is :in' do
      operator = Angus::Listing::Conditions::InCondition.operator

      expect(operator).to eq(:in)
    end
  end

  describe '#to_sql' do
    it 'returns an BETWEEN condition' do
      condition = Angus::Listing::Conditions::InCondition.new('id', 1, 2)
      sql = 'id IN (1, 2)'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
