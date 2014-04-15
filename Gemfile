source 'https://rubygems.org'

gem 'rails', '4.0.3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem "mongoid", git: 'git://github.com/mongoid/mongoid.git'
gem 'httparty'
gem 'agent_orange'
gem 'figaro'
gem 'rack-cors'
gem 'resque'

gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

group :development, :test do
  gem 'mongoid-rspec'
  gem "rspec-rails"
  gem "guard-rspec"
  gem "factory_girl_rails"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'resque_spec'
  gem 'simplecov', :require => false
end

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
end

gem 'therubyracer', platforms: :ruby
