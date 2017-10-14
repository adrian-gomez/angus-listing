module Angus
  module Listing
    module Conditions

      class InCondition
        def initialize(*options)
          @options = options
        end

        def to_sql
          value = @options.first
          sql_expression = @options[1, @options.length - 1].join(', ')

          "#{value} IN (#{sql_expression})"
        end

        def self.operator
          :in
        end
      end

    end
  end
end