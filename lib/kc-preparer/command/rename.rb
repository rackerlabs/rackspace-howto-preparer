

class KCPreparer::RenameCommand < KCPreparer::Command
  def execute
    document = KCPreparer::Document.new(@config, IO.read(@filename))
    KCPreparer::Nexus.delete_doc(@config, @previous_filename)
    KCPreparer::Nexus.publish_doc(@config, @filename, document)
  end
end
