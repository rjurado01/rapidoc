ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'rapidoc'

RSpec.configure do |config|
  config.mock_with :rspec
end
