require 'spec_helper'

require 'picasso/listing/conditions/between_condition'

describe Picasso::Listing::Conditions::BetweenCondition do

  describe '.operator' do
    it 'is :between' do
      operator = Picasso::Listing::Conditions::BetweenCondition.operator

      operator.should eq(:between)
    end
  end

  describe '#to_sql' do
    it 'returns an BETWEEN condition' do
      condition = Picasso::Listing::Conditions::BetweenCondition.new('id', 1, 2)
      sql = 'id BETWEEN 1 AND 2'

      condition.to_sql.should eq(sql)
    end
  end
end
