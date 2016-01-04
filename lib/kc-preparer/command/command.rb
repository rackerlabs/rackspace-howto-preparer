

class KCPreparer::Command
  attr_accessor :config, :change

  def initialize(config, commit, change)
    @config = config
    @commit = commit
    @change = change
  end

  # create a command to process each change
  def self.from_change(config, commit, change)
    case change['status']
    when 'added', 'changed', 'modified'
      KCPreparer::PutCommand.new(config, commit, change)
    when 'removed'
      KCPreparer::DeleteCommand.new(config, commit, change)
    when 'renamed'
      KCPreparer::RenameCommand.new(config, commit, change)
    end
  end
end
