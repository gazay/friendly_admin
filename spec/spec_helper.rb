require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = false
end