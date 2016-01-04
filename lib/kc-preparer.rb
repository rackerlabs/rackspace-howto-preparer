

class KCPreparer

  # application entry point
  def self.main(argv)
    config = KCPreparer::Config.new(argv)
    commands = config[:full] ? self.from_files(config) : self.from_github(config)

    puts "Updating #{commands.length} files:"
    $stdout.sync = true

    commands.each do |command|
      command.execute
      print '.'
      $stdout.flush
    end

    print '\r'
    puts 'Done'
  end

  # get all the files in the repository and publish them.
  def self.from_files(config)
    # TODO: we need to have this delete all of the old items, but we can only
    # do that once there is the ability to list the items needing deletion
    # files = Dir.glob(File.join('.', config[:kc_root], '**', '*.{md,html}'))
    []
  end

  # get the information on the files changed from github and create commands
  # for them
  def self.from_github(config)
    commit = KCPreparer::Github.get_commit(config)

    KCPreparer::Github.get_changes(config, commit).map do |change|
      KCPreparer::Command.from_change(config, commit, change)
    end
  end
end

require 'kc-preparer/config'

# services
require 'kc-preparer/document'
require 'kc-preparer/github'
require 'kc-preparer/nexus'

# commands
require 'kc-preparer/command/command'
require 'kc-preparer/command/delete'
require 'kc-preparer/command/put'
require 'kc-preparer/command/rename'
