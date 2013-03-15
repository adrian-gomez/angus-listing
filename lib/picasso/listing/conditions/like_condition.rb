module Picasso
  module Listing
    module Conditions

      class LikeCondition
        def initialize(op_a, op_b)
          @op_a = op_a
          @op_b = op_b
        end

        def to_sql
          "#@op_a LIKE #@op_b"
        end

        def self.operator
          :like
        end
      end
    end
  end
end