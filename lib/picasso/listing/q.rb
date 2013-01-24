require_relative 'conditions'

module Picasso
  module Listing

    # Wraps filter, paging and sorting behavior
    class Q

      attr_reader :filter
      attr_reader :paging
      attr_reader :sorting
      attr_reader :values

      # @param [Hash] options Q options
      # @option options [Array] :filter Filter options, see QFilter
      # @option options [Hash] :paging Paging options, see QPaging
      # @option options [Array] :sorting Sorting options, see QSorting
      # @option options [Array] :values Values for dataset filtering
      # @param [Array<Symbol>] columns Columns allowed to be filter and sorted by
      def initialize(options = {}, columns = [])
        @filter = QFilter.new(options[:filter] || options['filter'] || [], columns)
        @paging = QPaging.new(options[:paging] || options['paging'] || {})
        @sorting = QSorting.new(options[:sorting] || options['sorting'] || [], columns)
        @values = options[:values] || options['values'] || []
        @filter.validate!
        @sorting.validate!
      end

      # Returns a hash containing the options of the current Q object.
      #
      # The returned hash can be used then to create a new Q object.
      # Options:
      #  - filter
      #  - paging
      #  - sorting
      #  - values
      #
      # @return [Hash] A hash containing q options.
      def options
        {
          :filter => self.filter_options,
          :paging => self.paging_options,
          :sorting => self.sorting_options,
          :values => @values,
        }
      end

      # Returns Q Filter options.
      #
      # @return [Array] Array of filter options
      def filter_options
        @filter.options
      end

      # Returns Q Paging options.
      #
      # Options:
      #  - page [Integer] Page results number to obtain
      #  - per_page [Integer] Records count per page
      #
      # @return [Hash] Paging options
      def paging_options
        @paging.options
      end

      # Returns Q Sorting options
      #
      # @return [Array] Array of sorting options
      def sorting_options
        @sorting.options
      end
    end

    # Used to filter a dataset
    #
    # It creates a sql condition query given a set of filter options.
    #
    # filter options examples:
    #
    #   [:eq, :price, '?']
    #   [:in, :status, '?', ...]
    #   [:between, :due_date, '?', '?']
    #
    #   [:and, [:between, :due_date, '?', '?'], [:eq, :status, '?']]
    #
    #
    # The first element in each filter array relates to a operator condition like:
    #  - and
    #  - between
    #  - eq
    #  - in
    #  - not
    #  - or
    #
    # Please, look at {Picasso::Listing::Conditions} for further reference.
    class QFilter

      # Creates a filter object
      #
      # options is an array composed by conditions and other options arrays.
      #
      # @param [Array] options Filter options
      # @param [Array<#to_s>] Columns allowed to be filtered by
      def initialize(options, columns)
        @unescaped_options = options
        @options = escape_names(options, columns)
        @columns = columns
        @condition = Listing::Conditions.build_condition(@options)
      end

      # Return the same array option received while instantiating this object.
      def options
        @unescaped_options
      end

      # @return a sql string to be used in a WHERE condition
      def to_sql
        @condition.to_sql
      end

      # Verifies that the received options will not produce a SQL error neither be affected by a SQL injection attack.
      #
      # It checks the received options against:
      #  - valid columns
      #  - condition operators
      #  - place holder '?'
      #
      # @return [true] If filter validates
      #
      # @raise [NameError] When received options are not valid column names neither valid operators
      def validate!
        options = @unescaped_options.flatten
        invalid_options = options.reject do |option|
          option == '?' ||
          @columns.include?(option.to_sym) ||
            Listing::Conditions.operand?(option)
        end

        if invalid_options.any?
          raise NameError, "invalid column or operator name(s): #{invalid_options.join(', ')}"
        end

        true
      end

      private

      # Escapes column names, enclosing them with backticks ( ` )
      def escape_names(options, columns)
        options.map do |option|
          if option.kind_of?(Array)
            escape_names(option, columns)
          elsif columns.include?(option)
            option.to_s.split('.').map{ |o| "`#{o}`"}.join('.')
          else
            option
          end
        end
      end
    end


    # Adds pagination behavior.
    class QPaging
      attr_reader :page
      attr_reader :per_page

      DEFAULT_PAGE = 1
      DEFAULT_PER_PAGE = 10

      # @param [Hash<Symbol, Integer>,Hash<String, Integer>] options Paging options
      # @option options [Integer] :page Page number to retrieve
      # @option options [Integer] :per_page Number of records per page
      def initialize(options = {})
        page = options[:page] || options['page']
        per_page = options[:per_page] || options['per_page']
        @page = parse_integer(page, DEFAULT_PAGE)
        @page = 1 if @page == 0

        @per_page = parse_integer(per_page, DEFAULT_PER_PAGE)
      end

      # Returns current paging options.
      #
      # @return [Hash<Symbol, Integer>]
      def options
        { :page => @page, :per_page => @per_page }
      end

      # Returns pagination offset.
      #
      # @return [Integer]
      def offset
        (@page - 1) * @per_page
      end

      private
      # Parses an integer, if there is any parse error it then returns 'default'.
      #
      # @param [String] s Integer as a string
      # @param [Integer] default Default value to return if there is a parsing error
      #
      # @return [Integer] Parsed integer
      def parse_integer(s, default)
        Integer(s)
      rescue
        default
      end
    end

    # Sorting behavior for a Picasso::Listing::Dataset
    #
    # In order to instantiate a QSorting object, an array of sorting options is required.
    # Following there are some examples:
    #
    #   [:name, :asc]
    #   [:name, :quotes, :asc]
    #   [:name, :asc, :quotes, :desc]
    class QSorting

      # Returns true if the given direction is valid sorting direction one.
      #
      # @param [Symbol] direction
      #
      # @return [Boolean]
      def self.sort_direction?(direction)
        direction = direction.to_sym
        direction == :asc || direction == :desc
      end

      # @param [Array] options Sorting options
      # @param [Array<Symbol> Columns allowed to be sorted by
      def initialize(options, columns)
        @unescaped_options = options
        @options = escape_names(options, columns)
        @columns = columns
      end

      # Return the options used to construct the current Q Sorting.
      #
      # @return [Array]
      def options
        @unescaped_options
      end

      # Checks if the current object has been created with valid options.
      #
      # @return [true]
      #
      # @raise [NameError] When some options are not valid column names, neither valid directions
      # @raise [ArgumentError] When the sorting options are not in a correct sequence
      def validate!
        invalid_options = @unescaped_options.reject do |option|
          @columns.include?(option.to_sym) ||
            QSorting.sort_direction?(option)
        end


        if invalid_options.any?
          raise NameError, "invalid direction(s) or column name(s): #{invalid_options.join(', ')}"
        end

        unless valid_sorting_sequence?
          raise ArgumentError, "invalid sequence for sorting: #{@unescaped_options.join(', ')}"
        end
      end

      # Returns true if the sorting sequence is valid.
      #
      # A valid sorting sequence is one which follows this two rules:
      #
      #   - first item is not a sorting direction
      #   - there are no two consecutive sorting directions
      #
      # Valid examples:
      #   - [:id, :asc, false]
      #   - [:id, :description, :desc, :amount, :asc]
      #
      # Invalid exmaples:
      #   - [:desc, :id, :asc]
      #   - [:id, :description, :asc, :desc, :amount, :asc]
      #
      # @return [Boolean]
      def valid_sorting_sequence?
        @options.reduce(true) do |prev_sort, option|
          if QSorting.sort_direction?(option)
            return false if prev_sort
            true
          end
        end

        true
      end

      # Returns a string to be used in a SORT BY SQL fragment, i.e.:
      #
      #   `name` ASC, `code` DESC
      #
      # @return [String]
      def to_sql
        sql_options = []

        @options.each do |option|
          if QSorting.sort_direction?(option)
            sql_options[sql_options.length - 1] << " #{option.to_s.upcase}"
          else
            sql_options << option.to_s
          end
        end

        sql_options.join(', ')
      end

      private

      # Escapes column names, enclosing them with `
      def escape_names(options, columns)
        options = options.map do |option|
          if columns.include?(option.to_sym)
            "`#{option.to_s.gsub('.','`.`')}`"
          else
            option
          end
        end
      end
    end
  end
end
