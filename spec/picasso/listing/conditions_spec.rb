require 'spec_helper'

require 'picasso/listing/conditions'
require 'picasso/listing/conditions/equal_condition'
require 'picasso/listing/conditions/true_condition'

describe Picasso::Listing::Conditions do

  describe '.operand?' do
    context 'with known operator' do
      let (:operator) { Picasso::Listing::Conditions::EqualCondition.operator }

      it 'is true' do
        result = Picasso::Listing::Conditions.operand?(operator)

        result.should be
      end

      context 'with a Symbol' do
        it 'is true' do
          result = Picasso::Listing::Conditions.operand?(operator.to_sym)
          result.should be
        end
      end

      context 'with a String' do
        it 'is true' do
          result = Picasso::Listing::Conditions.operand?(operator.to_s)
          result.should be
        end
      end
    end

    it 'is false for unknown operators' do
      operator = :unknown

      result = Picasso::Listing::Conditions.operand?(operator)

      result.should be_false
    end
  end

  describe '.build_condition' do
    it 'builds a condition' do
      operator = Picasso::Listing::Conditions::EqualCondition.operator
      filter = [operator, '?', '?']

      condition = Picasso::Listing::Conditions.build_condition(filter)

      condition.should be_a(Picasso::Listing::Conditions::EqualCondition)
    end

    context 'with empty conditions' do
      it 'builds a TrueCondition' do
        condition = Picasso::Listing::Conditions.build_condition([])

        condition.should be_a(Picasso::Listing::Conditions::TrueCondition)
      end
    end

    context 'with unknown operator' do
      it 'raises a NameError' do
        operator = :unknown

        expect {
          Picasso::Listing::Conditions.build_condition([operator])
        }.to raise_error(NameError)

      end
    end
  end
end
