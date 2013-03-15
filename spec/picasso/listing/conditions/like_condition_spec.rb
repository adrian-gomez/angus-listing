require 'spec_helper'

require 'picasso/listing/conditions/like_condition'

describe Picasso::Listing::Conditions::LikeCondition do

  describe '.operator' do
    it 'is :like' do
      operator = Picasso::Listing::Conditions::LikeCondition.operator

      operator.should eq(:like)
    end
  end

  describe '#to_sql' do
    it 'returns a like condition' do
      condition = Picasso::Listing::Conditions::LikeCondition.new('name','%test%')
      sql = "name LIKE %test%"

      condition.to_sql.should eq(sql)
    end
  end
end