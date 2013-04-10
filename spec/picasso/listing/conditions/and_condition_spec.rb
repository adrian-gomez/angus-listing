require 'spec_helper'

require 'picasso/listing/conditions'
require 'picasso/listing/conditions/and_condition'
require 'picasso/listing/conditions/true_condition'

describe Picasso::Listing::Conditions::AndCondition do

  describe '.operator' do
    it 'is :and' do
      operator = Picasso::Listing::Conditions::AndCondition.operator

      operator.should eq(:and)
    end
  end

  describe '#to_sql' do
    it 'returns a SQL condition that ANDs some SQL conditions' do
      condition = Picasso::Listing::Conditions::AndCondition.new(:true, :true)

      true_condition = Picasso::Listing::Conditions::TrueCondition.new
      Picasso::Listing::Conditions.stub(:build_condition).and_return(true_condition)

      condition.to_sql.should match(/\sAND\s/)
    end

    context 'when only one condition' do
      it 'does not adds an AND' do
        condition = Picasso::Listing::Conditions::AndCondition.new(:true)

        true_condition = Picasso::Listing::Conditions::TrueCondition.new
        Picasso::Listing::Conditions.stub(:build_condition).and_return(true_condition)

        condition.to_sql.should eq("(#{true_condition.to_sql})")
      end
    end
  end
end
