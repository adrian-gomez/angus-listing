module Angus
  module Listing
    module Conditions

      class GreaterThanOrEqualCondition
        def initialize(op_a, op_b)
          @op_a = op_a
          @op_b = op_b
        end

        def to_sql
          "#{@op_a} >= #{@op_b}"
        end

        def self.operator
          :gte
        end

      end
    end
  end
end