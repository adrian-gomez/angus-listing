require 'spec_helper'

require 'angus/listing/conditions/like_condition'

describe Angus::Listing::Conditions::LikeCondition do
  describe '.operator' do
    it 'is :like' do
      operator = Angus::Listing::Conditions::LikeCondition.operator

      expect(operator).to eq(:like)
    end
  end

  describe '#to_sql' do
    it 'returns a like condition' do
      condition = Angus::Listing::Conditions::LikeCondition.new('name','%test%')
      sql = 'name LIKE %test%'

      expect(condition.to_sql).to eq(sql)
    end
  end
end
