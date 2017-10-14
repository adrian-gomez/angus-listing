require 'spec_helper'

require 'angus/listing/conditions/is_null_condition'

describe Angus::Listing::Conditions::IsNullCondition do

  describe '.operator' do
    it 'is :is_null' do
      operator = Angus::Listing::Conditions::IsNullCondition.operator

      expect(operator).to eq(:is_null)
    end
  end

  describe '#to_sql' do
    it 'returns an is null condition' do
      condition = Angus::Listing::Conditions::IsNullCondition.new('id')
      sql = 'id IS NULL'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
