

class KCPreparer::DeleteCommand < KCPreparer::Command
  def execute
    KCPreparer::Nexus.delete_doc(@config, @filename)
  end
end
