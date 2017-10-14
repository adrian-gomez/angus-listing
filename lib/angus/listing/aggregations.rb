require_relative 'aggregations/base'

module Angus
  module Listing

    # Namespace for handling core aggregations.
    #
    # Each aggregation is defined as a class that has the following methods:
    #
    #  - .function Returns a Symbol that identifies the operator in a filter conditions array.
    #
    #  - #default Default value when there's no result for the aggregation.
    #
    #  - #to_sql Returns a SQL fragment to be included in a WHERE condition.
    module Aggregations

      # Registers aggregations defined under Listing::Aggregations namespace.
      #
      # @api private
      def self.auto_register_aggregations
        @aggregations ||= {}
        self.constants(false).each do |c|
          klass = self.const_get(c)
          next if klass == Base

          @aggregations[klass.function] = klass
        end
      end

      # Builds an aggregation object for the given options.
      #
      # @param [Array<#to_sym>] options Aggregation options.
      #   The 1st element should match with a supported aggregation.
      #   The 2nd element should match a dataset column.
      #
      # @return [Object<Aggregation>] An aggregation object
      #
      # @raise [NameError] If the aggregation function is unknown
      def self.build(name, options, grouping = [])

        function = options.first.to_sym
        options = options[1, options.length - 1]

        klass = @aggregations[function]

        unless klass
          raise NameError, "unknown function #{function}"
        end

        klass.new(name, *options, grouping)
      end

    end
  end
end

[
  'sum_aggregation',
].each do |r|
  require_relative "aggregations/#{r}"
end

Angus::Listing::Aggregations.auto_register_aggregations