module Angus
  module Listing
    module Conditions

      class TrueCondition
        def to_sql
          '1 = 1'
        end

        def self.operator
          :true
        end
      end

    end
  end
end