require 'dry-types'

module Instapaper
  module Types
    include Dry.Types()

    # Coerces any value to string (replaces custom StringOrInteger union type)
    StringOrInteger = Types::Coercible::String

    # Handles boolean flags from API that come as "0"/"1" strings or 0/1 integers.
    BooleanFlag = Types::Constructor(Types::Bool) do |value|
      case value
      when '1', 1, 'true', true
        true
      when '0', 0, 'false', false, nil
        false
      else
        !!value
      end
    end

    # Converts Unix timestamps to Time objects
    UnixTime = Types::Time.constructor do |value|
      case value
      when ::Time
        value
      when nil
        nil
      else
        ::Time.at(value.to_i)
      end
    end
  end
end
