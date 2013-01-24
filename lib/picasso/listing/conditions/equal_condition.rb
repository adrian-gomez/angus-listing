module Picasso
  module Listing
    module Conditions

      class EqualCondition
        def initialize(op_a, op_b)
          @op_a = op_a
          @op_b = op_b
        end

        def to_sql
          "#{@op_a} = #{@op_b}"
        end

        def self.operator
          :eq
        end
      end

    end
  end
end
