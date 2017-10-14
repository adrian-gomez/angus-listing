module Angus
  module Listing
    module Conditions

      class BetweenCondition
        def initialize(op_a, op_b, op_c)
          @op_a = op_a
          @op_b = op_b
          @op_c = op_c
        end

        def to_sql
          "#{@op_a} BETWEEN #{@op_b} AND #{@op_c}"
        end

        def self.operator
          :between
        end
      end

    end
  end
end