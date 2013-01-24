require_relative 'base'

module Picasso
  module Listing
    module Aggregations

      class SumAggregation < Base

        # Returns the default value for a SUM
        #
        # @return [Integer]
        def default
          '0'
        end

        # Returns the corresponding sql SELECT clause.
        def sql_select
          sql = "SUM(#{self.column}) AS #{self.sql_alias}"

          if self.grouping.any?
            sql << ", " << self.grouping.join(', ')
          end

          sql
        end

        def self.function
          :sum
        end
      end

    end
  end
end
