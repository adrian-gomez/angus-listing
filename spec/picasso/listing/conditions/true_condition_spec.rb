require 'spec_helper'

require 'picasso/listing/conditions/true_condition'

describe Picasso::Listing::Conditions::TrueCondition do

  describe '.operator' do
    it 'is :true' do
      operator = Picasso::Listing::Conditions::TrueCondition.operator

      operator.should eq(:true)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that is always true' do
      condition = Picasso::Listing::Conditions::TrueCondition.new
      sql = '1 = 1'

      condition.to_sql.should eq(sql)
    end
  end
end
