

class KCPreparer

  # application entry point
  def self.main(argv)
    config = KCPreparer::Config.new(argv)
    commands = config[:full] ? self.from_files(config) : self.from_github(config)

    puts "Updating #{commands.length} files:"

    commands.each do |command|
      puts "Command: #{command.class.name} - #{command.filename}"
      command.execute
    end

    puts 'Done'
  end

  # get all the files in the repository and publish them.
  def self.from_files(config)
    files = Dir.glob(File.join('.', config[:kc_doc_root], '**', '*.{md,html}'))
    files.map { |f| KCPreparer::PutCommand.new(config, f) }
  end

  # get the information on the files changed from github and create commands
  # for them
  def self.from_github(config)
    commit = KCPreparer::Github.get_commit(config)

    KCPreparer::Github.get_changes(config, commit).map do |change|
      KCPreparer::Command.from_change(config, change)
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
