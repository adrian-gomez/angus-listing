module Angus
  module Listing
    module Conditions

      class IsNullCondition
        def initialize(option)
          @option = option
        end

        def to_sql
          "#{@option} IS NULL"
        end

        def self.operator
          :is_null
        end
      end

    end
  end
end