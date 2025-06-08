require 'dry-struct'
require 'instapaper/types'
require 'instapaper/bookmark'
require 'instapaper/highlight'
require 'instapaper/user'

module Instapaper
  class BookmarkList < Dry::Struct
    include Types
    transform_keys(&:to_sym)

    attribute :user, Instapaper::User
    attribute :bookmarks, Types::Array.of(Instapaper::Bookmark)
    attribute :highlights, Types::Array.of(Instapaper::Highlight)
    attribute? :delete_ids, Types::Array.of(Types::Integer).optional.default([].freeze)

    def each(&block)
      bookmarks.each(&block)
    end
  end
end
