

class KCPreparer::PutCommand < KCPreparer::Command
  def execute
    document = KCPreparer::Document.new(@config, IO.read(@filename))
    KCPreparer::Nexus.publish_doc(@config, @filename, document)
  end
end
