module Picasso
  module Listing
    module Aggregations

      class Base

        attr_reader :column
        attr_reader :grouping
        attr_reader :sql_alias

        def initialize(sql_alias, column, grouping = [])
          @sql_alias = sql_alias
          @column = column
          @grouping = grouping
        end

        # Returns the default value for a SUM.
        #
        # @abstract
        #
        # @return [Integer]
        def default
          raise NotImplementedError
        end

        # Returns the function of the current aggregation.
        #
        # @abstract
        def self.function
          raise NotImplementedError
        end

        # Returns the corresponding sql GROUP BY clause.
        #
        # @return [String]
        def sql_group_by
          if self.grouping.any?
            self.grouping.join(', ')
          else
            ''
          end
        end

        # Returns the group for the given record.
        #
        # Example:
        #
        #   grouping -> [:country, :city]
        #   record -> {:population => 3000, :country => 'US', :city => 'NEVADA'}
        #
        #   group_for -> ['US', 'NEVADA']
        #
        # @param [#[]] record
        #
        # @return [nil] when there is no grouping
        # @return [Object] when there is only one grouping element.
        # @return [Array] when there is more that one grouping element.
        def group_for(record)
          if self.grouping.empty?
            nil

          elsif self.grouping.length == 1
            record[self.grouping[0]]

          else
            self.grouping.map { |g| record[g] }
          end
        end

        # Extracts the calculation from a given relation.
        #
        # Example:
        #
        #   grouping -> [:country, :city]
        #   relation -> [
        #     {:population => 3000, :country => 'US', :city => 'NEVADA'},
        #     {:population => 7000, :country => 'US', :city => 'NEW YORK'},
        #   ]
        #
        #   return -> {
        #     ['US', 'NEVADA'] => 3000,
        #     ['US', 'NEW YORK'] => 7000
        #   }
        #
        # @param [ActiveRecord::Relation] relation
        #
        # @return [Object] when there is no grouping
        # @return [Hash] when there is some grouping
        def extract_from(relation)
          if self.grouping.any?
            extract_grouping_from(relation)
          else
            extract_single_from(relation)
          end
        end

        private
        # Extracts the calculation according the current grouping.
        #
        # @param [ActiveRecord::Relation] relation
        #
        # @return [Hash]
        def extract_grouping_from(relation)
          calculation = {}

          relation.each do |record|
            calculation[group_for(record)] = record[self.sql_alias]
          end

          calculation
        end

        # Extracts the calculation.
        #
        # @param [ActiveRecord::Relation] relation
        #
        # @return [Object]
        def extract_single_from(relation)
          relation.first[self.sql_alias] || self.default
        end

      end

    end
  end
end
