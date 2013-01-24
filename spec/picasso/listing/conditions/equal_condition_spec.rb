require 'spec_helper'

require 'picasso/listing/conditions/equal_condition'

describe Picasso::Listing::Conditions::EqualCondition do

  describe '.operator' do
    it 'is :eq' do
      operator = Picasso::Listing::Conditions::EqualCondition.operator

      operator.should eq(:eq)
    end
  end

  describe '#to_sql' do
    it 'returns an equal condition' do
      condition = Picasso::Listing::Conditions::EqualCondition.new('id', 1)
      sql = 'id = 1'

      condition.to_sql.should eq(sql)
    end
  end
end
