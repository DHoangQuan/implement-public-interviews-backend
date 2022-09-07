# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.1.6', '>= 6.1.6.1'

# for api
gem 'fast_jsonapi'

# for pagination
gem 'will_paginate', '~> 3.3'

# for currency
gem 'money-rails', '~>1.12'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'lefthook', require: false
  gem 'pronto', require: false
  gem 'pronto-rubocop', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', '>= 1.16.1', require: false
  gem 'rubocop-performance', '>= 1.11.3', require: false
  gem 'rubocop-rails', '>= 2.10.1', require: false
  gem 'rubocop-rspec', '>= 2.4.0', require: false
end

group :development do
  gem 'annotate'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'climate_control'
  gem 'shoulda-matchers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
