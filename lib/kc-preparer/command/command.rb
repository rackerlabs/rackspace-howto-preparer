

class KCPreparer::Command
  attr_accessor :config, :change

  def initialize(config, filename, previous_filename=nil)
    @config = config
    @filename = filename
    @previous_filename = previous_filename
  end

  # create a command to process each change
  def self.from_change(config, change)
    filename = change['filename']

    case change['status']
    when 'added', 'changed', 'modified'
      KCPreparer::PutCommand.new(config, filename)
    when 'removed'
      KCPreparer::DeleteCommand.new(config, filename)
    when 'renamed'
      KCPreparer::RenameCommand.new(config, filename, change['previous_filename'])
    end
  end
end
