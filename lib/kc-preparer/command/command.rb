

class KCPreparer::Command
  attr_accessor :config, :change

  def initialize(config, change)
    @config = config
    @change = change
  end

  # create a command to process each change
  def self.from_change(config, change)
    case change['status']
    when 'added', 'changed', 'modified'
      KCPreparer::PutCommand.new(config, change)
    when 'removed'
      KCPreparer::DeleteCommand.new(config, change)
    when 'renamed'
      KCPreparer::RenameCommand.new(config, change)
    end
  end
end
