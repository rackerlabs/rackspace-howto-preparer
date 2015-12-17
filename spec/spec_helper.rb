
require 'rspec'
require 'mocha'
require 'webmock/rspec'
require 'vcr'

require_relative '../lib/kc-preparer'


VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.mock_framework = :mocha
end
