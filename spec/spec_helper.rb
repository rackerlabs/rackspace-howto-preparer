
require 'rspec'
require 'mocha'
require 'webmock/rspec'
require 'vcr'

require 'simplecov'
SimpleCov.start


require_relative '../lib/kc-preparer'

SimpleCov.start do
  add_filter "/spec/"
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.mock_framework = :mocha
end
