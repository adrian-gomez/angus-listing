module Picasso
  module Listing

    # Namespace for handling core conditions.
    #
    # Each condition is defined as a class that has the following methods:
    #
    #  - .operator Returns a Symbol that identifies the operator in a filter conditions array
    #
    #  - #to_sql Returns a SQL fragment to be included in a WHERE condition.
    module Conditions

      # Registers operand conditions defined under Listing::Conditions namespace.
      #
      # @api private
      def self.auto_register_conditions
        @conditions ||= {}
        self.constants(false).each do |c|
          klass = self.const_get(c)
          @conditions[klass.operator] = klass
        end
      end

      # Builds an operand condition object for the given filter options.
      #
      # @param [Array<#to_sym>] options, @see Listing::QFilter
      #
      # @return [Object<Condition>] An operand condition object
      #
      # @raise [NameError] If the operator is unknown
      def self.build_condition(options)
        return TrueCondition.new if options.empty?

        operator = options.first.to_sym
        operands_options = options[1, options.length - 1]

        condition_klass = @conditions[operator]

        unless condition_klass
          raise NameError, "unknown operator #{operator}"
        end

        condition_klass.new(*operands_options)
      end

      # Returns true if the given name corresponds to an operand.
      #
      # @param [String] name
      #
      # @return [Boolean]
      def self.operand?(name)
        @conditions.include?(name.to_sym)
      end

    end
  end
end

[
  'and_condition',
  'between_condition',
  'equal_condition',
  'in_condition',
  'not_condition',
  'or_condition',
  'true_condition',
  'greater_than_or_equal_condition',
].each do |r|
  require_relative "conditions/#{r}"
end

Picasso::Listing::Conditions.auto_register_conditions
