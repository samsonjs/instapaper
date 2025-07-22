require 'openssl'
require 'base64'
require 'cgi'
require 'securerandom'

module Instapaper
  module OAuth
    class Header
      OAUTH_VERSION = '1.0'
      OAUTH_SIGNATURE_METHOD = 'HMAC-SHA1'

      attr_reader :method, :url, :params, :credentials

      def initialize(method, url, params, credentials)
        @method = method.to_s.upcase
        @url = url.to_s
        @params = params || {}
        @credentials = credentials
        @credentials.delete(:ignore_extra_keys)
      end

      def to_s
        "OAuth #{auth_header_params.map { |k, v| %(#{k}="#{escape(v)}") }.join(', ')}"
      end

      private

      def auth_header_params
        params = oauth_params.dup
        params['oauth_signature'] = signature
        params.sort.to_h
      end

      def oauth_params
        {
          'oauth_consumer_key' => credentials[:consumer_key],
          'oauth_token' => credentials[:token],
          'oauth_signature_method' => OAUTH_SIGNATURE_METHOD,
          'oauth_timestamp' => timestamp,
          'oauth_nonce' => nonce,
          'oauth_version' => OAUTH_VERSION,
        }.compact
      end

      def signature
        Base64.strict_encode64(
          OpenSSL::HMAC.digest(
            OpenSSL::Digest.new('sha1'),
            signing_key,
            signature_base_string,
          ),
        )
      end

      def signing_key
        "#{escape(credentials[:consumer_secret])}&#{escape(credentials[:token_secret] || '')}"
      end

      def signature_base_string
        [
          method,
          escape(normalized_url),
          escape(normalized_params),
        ].join('&')
      end

      def normalized_url
        uri = URI.parse(url)
        port = uri.port
        port = nil if (uri.scheme == 'http' && port == 80) || (uri.scheme == 'https' && port == 443)
        "#{uri.scheme}://#{uri.host}#{":#{port}" if port}#{uri.path}"
      end

      def normalized_params
        all_params = params.merge(oauth_params)
        all_params.map { |k, v| "#{escape(k)}=#{escape(v)}" }.sort.join('&')
      end

      def escape(value)
        CGI.escape(value.to_s).gsub('+', '%20')
      end

      def timestamp
        @timestamp ||= Time.now.to_i.to_s
      end

      def nonce
        @nonce ||= SecureRandom.hex(16)
      end
    end
  end
end
