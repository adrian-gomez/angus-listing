require_relative 'aggregations'
require_relative 'conditions'
require_relative 'q'
require_relative 'report'

module Picasso
  module Listing

    # Models a dataset that can be sorted, filter and paged
    class DataSet

      # Defines an aggregate column.
      #
      # @param [#to_sym] name Aggregate's name
      # @param [Array<#to_sym>] Aggregate's expression
      #   An expression consists of an array containing an aggregate function and a column name.
      #
      #   Ex:
      #     [:sum, :amount]
      #
      def self.aggregate(name, expression, grouping = [])
        @aggregates ||= {}
        @aggregates[name] = Aggregations.build(name, expression, grouping)
      end

      # Defines a dataset column
      #
      # @param [#to_s] name Column's name
      def self.column(name)
        @columns ||= []
        @columns << name.to_sym
      end

      # param [Hash] q Q options, see Picasso::Listing::Q.new
      def initialize(q = nil)
        q ||= {}
        @q = Q.new(q, columns, self.relation.table_name)
      end

      # Returns the calculations for this dataset.
      #
      # @param [ActiveRecord::Relation] relation Relation on which the calculations will be computed.
      #   If relation is nil, then the aggregations will be computed over {#relation}.
      #
      # @return [Hash<#to_s, Object>]
      def calculations(relation = nil)
        relation ||= apply_filter(self.relation)

        calculations = {}

        aggregates.each do |name, aggregate|

          value = if @q.select.calculation?(name)
            aggregate_relation = relation.select(aggregate.sql_select)
                                         .group(aggregate.sql_group_by)
                                         .except(:includes)

            aggregate.extract_from(aggregate_relation)
          else
            nil
          end

          calculations[name] = value
        end

        calculations
      end

      # Returns the records count for this dataset.
      #
      # @param [ActiveRecord::Relation] relation Relation on which the count will be computed.
      #   If relation is nil, then the count will be computed over {#relation}.
      #
      # @return [Integer]
      def count(relation = nil)
        relation ||= apply_filter(self.relation)

        relation.except(:includes).count
      end

      # Returns a list of records after applying filtering, sorting and paging.
      #
      # @param [ActiveRecord::Relation] Relation over which the listing will be applied
      #
      # @return [Array]
      def list(relation = nil)
        relation ||= apply_filter(self.relation)

        apply_paging(
            apply_sorting(relation)
        ).to_a
      end

      # Builds a report for this dataset.
      #
      # @return [Listing::Report] report
      def report
        filtered = apply_filter(self.relation)

        count = self.count(filtered) if @q.select.count?

        list = if @q.select.list?
          self.list(filtered)
        else
          []
        end

        calculations = self.calculations(filtered)
        Listing::Report.new(
          @q.options,
          list,
          calculations,
          count
        )
      end

      # Returns filter options.
      #
      # @see Q#filter_options
      def filter_options
        @q.filter_options
      end

      # Returns filter options.
      #
      # @see Q#paging_options
      def paging_options
        @q.paging_options
      end

      # Returns sorting options.
      #
      # @see Q#sorting_options
      def sorting_options
        @q.sorting_options
      end

      private
      # Applies the current QFilter to the given relation.
      #
      # @param [ActiveRecord::Relation] relation
      #
      # @return [ActiveRecord::Relation]
      def apply_filter(relation)
        relation.where(@q.filter.to_sql, *@q.values)
      end

      # Applies the current QPaging to the given relation.
      #
      # @param [ActiveRecord::Relation] relation
      #
      # @return [ActiveRecord::Relation]
      def apply_paging(relation)
        per_page = @q.paging.per_page
        offset = @q.paging.offset

        relation.limit(per_page).offset(offset)
      end

      # Applies the current QSorting to the given relation.
      #
      # @param [ActiveRecord::Relation] relation
      #
      # @return [ActiveRecord::Relation]
      def apply_sorting(relation)
        relation.order(@q.sorting.to_sql)
      end

      # Returns the aggregates defined for this dataset
      #
      # @return [Hash<Symbol, Object<Aggregation>>]
      def aggregates
        self.class.instance_variable_get(:@aggregates) || {}
      end

      # Returns the columns defined for this dataset.
      #
      # @return [Array<Symbol>]
      def columns
        self.class.instance_variable_get(:@columns)
      end
    end
  end
end
