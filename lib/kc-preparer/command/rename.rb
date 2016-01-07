

class KCPreparer::RenameCommand < KCPreparer::Command
  def execute
    document = KCPreparer::Document.new(@config, @change['filename'], IO.read(@change['filename']))
    KCPreparer::Nexus.delete_doc(@config, @change['previous_filename'])
    KCPreparer::Nexus.publish_doc(@config, document)
  end
end
