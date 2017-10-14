module Angus
  module Listing
    module Conditions

      class OrCondition
        def initialize(*options)
          @options = options
        end

        def to_sql
          conditions = @options.map do |option|
            Listing::Conditions.build_condition(option)
          end

          "(#{conditions.map(&:to_sql).join(' OR ')})"
        end

        def self.operator
          :or
        end
      end

    end
  end
end