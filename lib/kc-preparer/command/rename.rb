

class KCPreparer::RenameCommand < KCPreparer::Command
  def execute
    # find the old version of the document in github.  Commits can have one or
    # two parents, but only one of those commits should actually have the file
    parents = @commit['parents'].map { |parent| parent['sha'] }

    old_doc = parents.find do |sha|
      KCPreparer::Github.get_file_at_sha(@config, @change['previous_filename'], sha)
    end

    if old_doc
      document = KCPreparer::Document.new(@config, old_doc)
      KCPreparer::Nexus.delete_doc(@config, document)
    end

    # put the new version of the document
    document = KCPreparer::Document.new(@config, IO.read(@config['filename']))
    KCPreparer::Nexus.publish_doc(@config, document)
  end
end
