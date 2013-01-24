require 'spec_helper'

require 'picasso/listing/conditions/greater_than_or_equal_condition'

describe Picasso::Listing::Conditions::GreaterThanOrEqualCondition do

  describe '.operator' do
    it 'is :gte' do
      operator = Picasso::Listing::Conditions::GreaterThanOrEqualCondition.operator

      operator.should eq(:gte)
    end
  end

  describe '#to_sql' do
    it 'returns an greater than equal condition' do
      condition = Picasso::Listing::Conditions::GreaterThanOrEqualCondition.new('id', 1)
      sql = 'id >= 1'

      condition.to_sql.should eq(sql)
    end
  end
end
