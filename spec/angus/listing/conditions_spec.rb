require 'spec_helper'

require 'angus/listing/conditions'
require 'angus/listing/conditions/equal_condition'
require 'angus/listing/conditions/true_condition'

describe Angus::Listing::Conditions do
  describe '.operand?' do
    context 'with known operator' do
      let (:operator) { Angus::Listing::Conditions::EqualCondition.operator }

      it 'is true' do
        result = Angus::Listing::Conditions.operand?(operator)

        expect(result).to be
      end

      context 'with a Symbol' do
        it 'is true' do
          result = Angus::Listing::Conditions.operand?(operator.to_sym)
          expect(result).to be
        end
      end

      context 'with a String' do
        it 'is true' do
          result = Angus::Listing::Conditions.operand?(operator.to_s)
          expect(result).to be
        end
      end
    end

    it 'is false for unknown operators' do
      operator = :unknown

      result = Angus::Listing::Conditions.operand?(operator)

      expect(result).to be(false)
    end
  end

  describe '.build_condition' do
    it 'builds a condition' do
      operator = Angus::Listing::Conditions::EqualCondition.operator
      filter = [operator, '?', '?']

      condition = Angus::Listing::Conditions.build_condition(filter)

      expect(condition).to be_a(Angus::Listing::Conditions::EqualCondition)
    end

    context 'with empty conditions' do
      it 'builds a TrueCondition' do
        condition = Angus::Listing::Conditions.build_condition([])

        expect(condition).to be_a(Angus::Listing::Conditions::TrueCondition)
      end
    end

    context 'with unknown operator' do
      it 'raises a NameError' do
        operator = :unknown

        expect {
          Angus::Listing::Conditions.build_condition([operator])
        }.to raise_error(NameError)
      end
    end
  end
end
