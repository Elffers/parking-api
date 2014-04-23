source 'https://rubygems.org'
ruby '2.1.1'
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
gem 'rake', '=10.1.0'

gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

group :test do
  gem 'mongoid-rspec'
  gem "rspec-rails"
  gem "guard-rspec"
  gem "factory_girl_rails"
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
  gem "capistrano-resque", github: "sshingler/capistrano-resque", require: false
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'therubyracer', platforms: :ruby
