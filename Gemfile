source 'https://rubygems.org'

gem 'rake'
gem 'yard'

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
