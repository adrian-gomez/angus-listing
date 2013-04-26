module Picasso
  module Listing

    # Models a report.
    #
    # A report is a result of previously applying calculations, filtering, sorting,
    #   and paging to a given dataset.
    class Report
      attr_reader :calculations
      attr_reader :count
      attr_reader :list
      attr_reader :q

      # @param [Hash] q Q Options
      # @param [Array] list Records list
      # @param [Hash] calculations
      # @param [Integer] count Total count of record without taking care of filtering and paging
      def initialize(q, list, calculations, count)
        @q = q
        @list = list
        @calculations = calculations
        @count = count
      end

      # Returns the total count of pages for the filtering that produced the current list.
      def page_count
        if @count
          (@count.to_f / @q[:paging][:per_page]).ceil
        end
      end
    end

  end
end

