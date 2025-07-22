require 'addressable/uri'
require 'base64'
require 'instapaper/oauth'

module Instapaper
  module HTTP
    class Headers
      def initialize(client, request_method, url, options = {})
        @client = client
        @request_method = request_method.to_sym
        @uri = Addressable::URI.parse(url)
        @options = options
      end

      def request_headers
        {
          user_agent: @client.user_agent,
          authorization: oauth_header,
        }
      end

      private

      def oauth_header
        Instapaper::OAuth::Header.new(@request_method, @uri, @options, credentials.merge(ignore_extra_keys: true))
      end

      # Authentication hash
      #
      # @return [Hash]
      def credentials
        if @client.credentials?
          {
            consumer_key: @client.consumer_key,
            consumer_secret: @client.consumer_secret,
            token: @client.oauth_token,
            token_secret: @client.oauth_token_secret,
          }
        else
          @client.consumer_credentials
        end
      end
    end
  end
end
