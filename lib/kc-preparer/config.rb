
require 'forwardable'
require 'optparse'


class KCPreparer::Config
  extend Forwardable
  def_delegators :@config, :[], :[]=

  TRAVIS_VARS = [
    'TRAVIS_COMMIT',
    'TRAVIS_REPO_SLUG',
    'TRAVIS_PULL_REQUEST'
  ]

  GENERAL_VARS = [
    'KC_DOC_ROOT',
    'KC_BASE_URL',
    'NEXUS_URL',
    'NEXUS_API_KEY'
  ]

  def initialize(argv)
    @config = {}
    @argv = argv

    # defaults
    self[:full] = false

    get_commandline_options()
    get_environment_options()
  end

  def get_commandline_options()
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: kc-preparer [options]"

      opts.on('--full', "Prepare all the files") do |full|
        self[:full] = full
      end
    end

    parser.parse!(@argv)
  end

  def get_environment_options()
    vars = self[:full] ? (GENERAL_VARS) : (GENERAL_VARS + TRAVIS_VARS)

    vars.each do |key|
      value = ENV[key]
      raise ArgumentError, "Environment variable #{key} not found." if value.nil?
      self[key.downcase.to_sym] = value
    end
  end
end
