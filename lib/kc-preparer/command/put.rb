

class KCPreparer::PutCommand < KCPreparer::Command
  def execute
    document = KCPreparer::Document.new(@config, IO.read(@change['filename']))
    KCPreparer::Nexus.publish_doc(@config, @change['filename'], document)
  end
end
