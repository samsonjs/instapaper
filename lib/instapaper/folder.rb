require 'dry-struct'
require 'instapaper/types'

module Instapaper
  class Folder < Dry::Struct
    include Types
    transform_keys(&:to_sym)

    attribute :title, Types::String
    attribute? :display_title, Types::String
    attribute :sync_to_mobile, Types::BooleanFlag
    attribute :folder_id, Types::Integer
    attribute :position, Types::Coercible::Float
    attribute :type, Types::String
    attribute? :slug, Types::String
  end
end
