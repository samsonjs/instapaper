require 'dry-struct'
require 'instapaper/types'

module Instapaper
  class Highlight < Dry::Struct
    include Types
    transform_keys(&:to_sym)

    attribute :type, Types::String
    attribute :highlight_id, Types::Integer
    attribute :bookmark_id, Types::Integer
    attribute :text, Types::String
    attribute :position, Types::Integer
    attribute :time, Types::Integer.optional
  end
end
