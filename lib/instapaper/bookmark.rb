require 'dry-struct'
require 'instapaper/types'

module Instapaper
  class Bookmark < Dry::Struct
    include Types

    transform_keys(&:to_sym)

    attribute :type, Types::String
    attribute :bookmark_id, Types::Integer
    attribute :url, Types::String
    attribute :title, Types::String
    attribute? :description, Types::String
    attribute? :instapaper_hash, Types::String
    attribute? :private_source, Types::String
    attribute? :progress_timestamp, Types::UnixTime
    attribute? :time, Types::UnixTime
    attribute? :progress, Types::StringOrInteger
    attribute? :starred, Types::StringOrInteger
  end
end
