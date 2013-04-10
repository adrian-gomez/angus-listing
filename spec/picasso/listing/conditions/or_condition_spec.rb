require 'spec_helper'

require 'picasso/listing/conditions'
require 'picasso/listing/conditions/or_condition'
require 'picasso/listing/conditions/true_condition'

describe Picasso::Listing::Conditions::OrCondition do

  describe '.operator' do
    it 'is :or' do
      operator = Picasso::Listing::Conditions::OrCondition.operator

      operator.should eq(:or)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that ORs some SQL conditions' do
      condition = Picasso::Listing::Conditions::OrCondition.new(:true, :true)

      true_condition = Picasso::Listing::Conditions::TrueCondition.new
      Picasso::Listing::Conditions.stub(:build_condition).and_return(true_condition)

      condition.to_sql.should match(/\sOR\s/)
    end

    describe 'when only one condition' do
      it 'does not adds an OR' do
        condition = Picasso::Listing::Conditions::OrCondition.new(:true)

        true_condition = Picasso::Listing::Conditions::TrueCondition.new
        Picasso::Listing::Conditions.stub(:build_condition).and_return(true_condition)

        condition.to_sql.should eq("(#{true_condition.to_sql})")
      end
    end
  end
end
