require 'dry-struct'
require 'instapaper/types'

module Instapaper
  class Credentials < Dry::Struct
    include Types
    transform_keys(&:to_sym)

    attribute :oauth_token, Types::String
    attribute :oauth_token_secret, Types::String
  end
end
