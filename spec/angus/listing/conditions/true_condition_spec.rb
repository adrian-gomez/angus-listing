require 'spec_helper'

require 'angus/listing/conditions/true_condition'

describe Angus::Listing::Conditions::TrueCondition do
  describe '.operator' do
    it 'is :true' do
      operator = Angus::Listing::Conditions::TrueCondition.operator

      expect(operator).to eq(:true)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that is always true' do
      condition = Angus::Listing::Conditions::TrueCondition.new
      sql = '1 = 1'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
