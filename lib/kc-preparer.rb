

class KCPreparer

  # application entry point
  def self.main(argv)
    config = KCPreparer::Config.new(argv)
    commands = config[:full] ? self.from_files(config) : self.from_github(config)

    # handle deletes
    delete_commands = commands.select { |command| command.class == KCPreparer::DeleteCommand }

    if !delete_commands.empty?
      puts "\nDeleting #{delete_commands.length} files:"
      self.execute(delete_commands)
      puts ""
    end

    # handle adds
    put_commands = commands.select { |command| command.class == KCPreparer::PutCommand }

    if !put_commands.empty?
      puts "\nPutting #{put_commands.length} files:"
      self.execute(put_commands)
    end

    # special cases
    puts "\nExecuting special cases:"
    self.execute(self.special_cases(config))

    puts "\nDone."
  end

  def self.execute(commands)
    commands.each do |command|
      puts "Command: #{command.class.name} - #{command.filename}"
      command.execute
    end
  end

  # get all the files in the repository and publish them.
  def self.from_files(config)
    files = Dir.glob(File.join(config[:kc_doc_root], '**', '*.{md,html}'))
    files.map { |f| KCPreparer::PutCommand.new(config, f) }
  end

  # get the information on the files changed from github and create commands
  # for them
  def self.from_github(config)
    KCPreparer::Git.get_file_changes(config).map do |change|
      KCPreparer::Command.from_change(config, change)
    end
  end

  # get the special cases commands
  def self.special_cases(config)
    [
      KCPreparer::IndexCommand.new(config, File.join(config[:kc_doc_root], 'index.html')),
      KCPreparer::AllArticlesCommand.new(config, 'products.csv')
    ]
  end
end

require 'kc-preparer/config'
require 'kc-preparer/document'
require 'kc-preparer/git'
require 'kc-preparer/nexus'
require 'kc-preparer/parser'

# commands
require 'kc-preparer/command/command'

require 'kc-preparer/command/all_articles'
require 'kc-preparer/command/delete'
require 'kc-preparer/command/index'
require 'kc-preparer/command/put'
