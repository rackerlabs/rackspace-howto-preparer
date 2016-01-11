

class KCPreparer::IndexCommand < KCPreparer::Command

  # Handle the special case of the index, by putting it as "/" in the content
  # repository
  def execute
    document = KCPreparer::Document.new(@config, IO.read(@filename))
    KCPreparer::Nexus.publish_doc(@config, "", document)
  end
end
