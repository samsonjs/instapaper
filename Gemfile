source 'https://rubygems.org'

gem 'rake'
gem 'yard'
gem 'simple_oauth', git: 'https://github.com/samsonjs/simple_oauth.git', tag: 'v0.3.2'

gem 'jruby-openssl', platforms: :jruby
gem 'json', platforms: :mri_19

group :development do
  gem 'bundler'
  gem 'kramdown'
end

group :test do
  gem 'rspec', '~> 3'
  gem 'rubocop', '>= 0.27'
  gem 'simplecov'
  gem 'webmock', '>= 1.22'
end

gemspec
