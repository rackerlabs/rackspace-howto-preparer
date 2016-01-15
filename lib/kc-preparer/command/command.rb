

class KCPreparer::Command
  attr_accessor :config, :filename

  def initialize(config, filename)
    @config = config
    @filename = filename
  end

  # create a command to process each change
  def self.from_change(config, change)
    filename = change[:filename]

    case change[:status]
    when 'D'
      KCPreparer::DeleteCommand.new(config, filename)
    else
      KCPreparer::PutCommand.new(config, filename)
    end
  end
end
