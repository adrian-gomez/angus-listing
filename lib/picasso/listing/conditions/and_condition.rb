module Picasso
  module Listing
    module Conditions

      class AndCondition
        def initialize(*options)
          @options = options
        end

        def to_sql
          conditions = @options.map do |option|
            Listing::Conditions.build_condition(option)
          end

          "(#{conditions.map(&:to_sql).join(' AND ')})"
        end

        def self.operator
          :and
        end
      end

    end
  end
end
