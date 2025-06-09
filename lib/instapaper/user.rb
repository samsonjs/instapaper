require 'dry-struct'
require 'instapaper/types'

module Instapaper
  class User < Dry::Struct
    include Types
    transform_keys(&:to_sym)

    attribute :username, Types::String
    attribute :user_id, Types::Integer
    attribute :type, Types::String
    attribute? :subscription_is_active, Types::BooleanFlag.optional
  end
end
