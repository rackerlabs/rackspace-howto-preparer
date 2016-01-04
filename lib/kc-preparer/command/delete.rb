

class KCPreparer::DeleteCommand < KCPreparer::Command
  def execute
    data = KCPreparer::Github.get_url_contents(@config, @change['raw_url'])
    document = KCPreparer::Document.new(@config, data)
    KCPreparer::Nexus.delete_doc(@config, document)
  end
end
