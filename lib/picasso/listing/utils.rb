require_relative 'conditions'

module Picasso
  module Listing

    module Utils

      # Adds a namespace to the given column if necessary.
      #
      # If column contains a dot ( . ), then it does not adds nothing.
      # Otherwhise, it prepends it with ns param.
      #
      # @param [String] column Name of the column
      # @param [String] ns Namespace
      #
      # @return [String] Properly namespaced name
      def self.add_namespace(column, ns)
        if ns && column !~ /\./
          "#{ns}.#{column}"
        else
          column
        end
      end

    end
  end
end
