require 'spec_helper'

require 'picasso/listing/conditions/in_condition'

describe Picasso::Listing::Conditions::InCondition do

  describe '.operator' do
    it 'is :in' do
      operator = Picasso::Listing::Conditions::InCondition.operator

      operator.should eq(:in)
    end
  end

  describe '#to_sql' do
    it 'returns an BETWEEN condition' do
      condition = Picasso::Listing::Conditions::InCondition.new('id', 1, 2)
      sql = 'id IN (1, 2)'

      condition.to_sql.should eq(sql)
    end
  end
end
