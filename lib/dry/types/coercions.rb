# frozen_string_literal: true

module Dry
  module Types
    # Common coercion functions used by the built-in `Params` and `JSON` types
    #
    # @api public
    module Coercions
      include Dry::Core::Constants

      # @param [#to_str, Object] input
      #
      # @return [Date, Object]
      #
      # @see Date.parse
      #
      # @api public
      def to_date(input, &block)
        if input.respond_to?(:to_str)
          begin
            fast_string_to_date(input) || ::Date.parse(input)
          rescue ArgumentError, RangeError => e
            CoercionError.handle(e, &block)
          end
        elsif input.is_a?(::Date)
          input
        elsif block_given?
          yield
        else
          raise CoercionError, "#{input.inspect} is not a string"
        end
      end

      # @param [#to_str, Object] input
      #
      # @return [DateTime, Object]
      #
      # @see DateTime.parse
      #
      # @api public
      def to_date_time(input, &block)
        if input.respond_to?(:to_str)
          begin
            ::DateTime.parse(input)
          rescue ArgumentError => e
            CoercionError.handle(e, &block)
          end
        elsif input.is_a?(::DateTime)
          input
        elsif block_given?
          yield
        else
          raise CoercionError, "#{input.inspect} is not a string"
        end
      end

      # @param [#to_str, Object] input
      #
      # @return [Time, Object]
      #
      # @see Time.parse
      #
      # @api public
      def to_time(input, &block)
        if input.respond_to?(:to_str)
          begin
            fast_string_to_time(input) || ::Time.parse(input)
          rescue ArgumentError => e
            CoercionError.handle(e, &block)
          end
        elsif input.is_a?(::Time)
          input
        elsif block_given?
          yield
        else
          raise CoercionError, "#{input.inspect} is not a string"
        end
      end

      # @param [#to_sym, Object] input
      #
      # @return [Symbol, Object]
      #
      # @raise CoercionError
      #
      # @api public
      def to_symbol(input, &block)
        input.to_sym
      rescue NoMethodError => e
        CoercionError.handle(e, &block)
      end

      private

      # Checks whether String is empty
      #
      # @param [String, Object] value
      #
      # @return [Boolean]
      #
      # @api private
      def empty_str?(value)
        EMPTY_STRING.eql?(value)
      end

      ISO_DATE = /\A(\d{4})-(\d\d)-(\d\d)\z/.freeze
      def fast_string_to_date(string)
        if string =~ ISO_DATE
          ::Date.new $1.to_i, $2.to_i, $3.to_i
        end
      end

      ISO_DATETIME = /
        \A
        (\d{4})-(\d\d)-(\d\d)(?:T|\s)            # 2020-06-20T
        (\d\d):(\d\d):(\d\d)(?:\.(\d{1,6})\d*)?  # 10:20:30.123456
        (?:(Z(?=\z)|[+-]\d\d)(?::?(\d\d))?)?     # +09:00
        \z
      /x.freeze
      def fast_string_to_time(string)
        return unless ISO_DATETIME =~ string

        usec = $7.to_i
        usec_len = $7&.length
        if usec_len&.< 6
          usec *= 10**(6 - usec_len)
        end

        if $8
          offset = $8 == "Z" ? 0 : $8.to_i * 3600 + $9.to_i * 60
        end

        ::Time.local($1.to_i, $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i, usec, offset)
      end
    end
  end
end
