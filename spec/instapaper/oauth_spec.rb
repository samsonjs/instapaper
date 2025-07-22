require 'spec_helper'

describe Instapaper::OAuth::Header do
  let(:method) { 'POST' }
  let(:url) { 'https://www.instapaper.com/api/1/bookmarks/list' }
  let(:params) { {folder_id: '12345', limit: '10'} }
  let(:credentials) do
    {
      consumer_key: 'test_consumer_key',
      consumer_secret: 'test_consumer_secret',
      token: 'test_token',
      token_secret: 'test_token_secret',
    }
  end

  subject { described_class.new(method, url, params, credentials) }

  describe '#initialize' do
    it 'upcases the HTTP method' do
      header = described_class.new('get', url, params, credentials)
      expect(header.method).to eq('GET')
    end

    it 'converts URL to string' do
      uri = URI.parse(url)
      header = described_class.new(method, uri, params, credentials)
      expect(header.url).to eq(url)
    end

    it 'handles nil params' do
      header = described_class.new(method, url, nil, credentials)
      expect(header.params).to eq({})
    end

    it 'removes ignore_extra_keys from credentials' do
      creds_with_extra = credentials.merge(ignore_extra_keys: true)
      header = described_class.new(method, url, params, creds_with_extra)
      expect(header.credentials).not_to have_key(:ignore_extra_keys)
    end
  end

  describe '#to_s' do
    it 'returns a properly formatted OAuth header' do
      # Stub time and nonce for consistent output
      allow(subject).to receive(:timestamp).and_return('1234567890')
      allow(subject).to receive(:nonce).and_return('abcdef1234567890')

      header_string = subject.to_s
      expect(header_string).to start_with('OAuth ')
      expect(header_string).to include('oauth_consumer_key="test_consumer_key"')
      expect(header_string).to include('oauth_nonce="abcdef1234567890"')
      expect(header_string).to include('oauth_signature=')
      expect(header_string).to include('oauth_signature_method="HMAC-SHA1"')
      expect(header_string).to include('oauth_timestamp="1234567890"')
      expect(header_string).to include('oauth_token="test_token"')
      expect(header_string).to include('oauth_version="1.0"')
    end

    it 'sorts OAuth parameters alphabetically' do
      allow(subject).to receive(:timestamp).and_return('1234567890')
      allow(subject).to receive(:nonce).and_return('abcdef1234567890')

      header_string = subject.to_s
      params_order = header_string.scan(/oauth_\w+(?==)/)
      expect(params_order).to eq(params_order.sort)
    end
  end

  describe 'signature generation' do
    it 'generates consistent signatures for the same input' do
      allow(subject).to receive(:timestamp).and_return('1234567890')
      allow(subject).to receive(:nonce).and_return('abcdef1234567890')

      header1 = subject.to_s
      header2 = subject.to_s

      sig1 = header1[/oauth_signature="([^"]+)"/, 1]
      sig2 = header2[/oauth_signature="([^"]+)"/, 1]

      expect(sig1).to eq(sig2)
    end

    it 'generates different signatures for different parameters' do
      allow(subject).to receive(:timestamp).and_return('1234567890')
      allow(subject).to receive(:nonce).and_return('abcdef1234567890')

      header1 = subject.to_s

      different_params = {folder_id: '67890', limit: '20'}
      subject2 = described_class.new(method, url, different_params, credentials)
      allow(subject2).to receive(:timestamp).and_return('1234567890')
      allow(subject2).to receive(:nonce).and_return('abcdef1234567890')

      header2 = subject2.to_s

      sig1 = header1[/oauth_signature="([^"]+)"/, 1]
      sig2 = header2[/oauth_signature="([^"]+)"/, 1]

      expect(sig1).not_to eq(sig2)
    end
  end

  describe 'URL normalization' do
    it 'removes default HTTP port 80' do
      header = described_class.new(method, 'http://example.com:80/path', params, credentials)
      expect(header.send(:normalized_url)).to eq('http://example.com/path')
    end

    it 'removes default HTTPS port 443' do
      header = described_class.new(method, 'https://example.com:443/path', params, credentials)
      expect(header.send(:normalized_url)).to eq('https://example.com/path')
    end

    it 'keeps non-default ports' do
      header = described_class.new(method, 'https://example.com:8080/path', params, credentials)
      expect(header.send(:normalized_url)).to eq('https://example.com:8080/path')
    end
  end

  describe 'parameter encoding' do
    it 'properly encodes spaces as %20' do
      params_with_spaces = {title: 'Hello World'}
      header = described_class.new(method, url, params_with_spaces, credentials)
      allow(header).to receive(:timestamp).and_return('1234567890')
      allow(header).to receive(:nonce).and_return('abcdef1234567890')

      normalized = header.send(:normalized_params)
      expect(normalized).to include('title=Hello%20World')
      expect(normalized).not_to include('+')
    end

    it 'properly encodes special characters' do
      params_with_special = {title: 'Test & Co.'}
      header = described_class.new(method, url, params_with_special, credentials)
      allow(header).to receive(:timestamp).and_return('1234567890')
      allow(header).to receive(:nonce).and_return('abcdef1234567890')

      normalized = header.send(:normalized_params)
      expect(normalized).to include('title=Test%20%26%20Co.')
    end
  end

  describe 'compatibility' do
    it 'handles missing token credentials (2-legged OAuth)' do
      two_legged_creds = {
        consumer_key: 'test_consumer_key',
        consumer_secret: 'test_consumer_secret',
      }
      header = described_class.new(method, url, params, two_legged_creds)
      expect { header.to_s }.not_to raise_error
      expect(header.to_s).not_to include('oauth_token=')
    end
  end
end
