require 'spec_helper'

require 'picasso/listing/conditions'
require 'picasso/listing/conditions/not_condition'
require 'picasso/listing/conditions/true_condition'

describe Picasso::Listing::Conditions::NotCondition do

  describe '.operator' do
    it 'is :not' do
      operator = Picasso::Listing::Conditions::NotCondition.operator

      operator.should eq(:not)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that negates another SQL condition' do
      condition = Picasso::Listing::Conditions::NotCondition.new(:another)

      another_condition = Picasso::Listing::Conditions::TrueCondition.new
      Picasso::Listing::Conditions.stub(:build_condition).and_return(another_condition)


      condition.to_sql.should match(/^NOT\s/)
    end
  end
end
