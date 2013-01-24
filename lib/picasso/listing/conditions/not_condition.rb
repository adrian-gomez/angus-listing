module Picasso
  module Listing
    module Conditions

      class NotCondition
        def initialize(condition_options)
          @condition_options = condition_options
        end

        def to_sql
          condition = Listing::Conditions.build_condition(@condition_options)

          "NOT (#{condition.to_sql})"
        end

        def self.operator
          :not
        end
      end

    end
  end
end
