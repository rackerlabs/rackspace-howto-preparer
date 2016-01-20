

class KCPreparer::Git
  def self.get_file_changes(config)
    current = config[:travis_commit] || 'HEAD'

    # grab the parents of the current commit in question
    parents = `git rev-list --parents -n1 #{current}`.chomp().split()

    if parents.length > 2
      # two parents! find the common ancestor between them, and use that as the base
      base = `git merge-base -a #{parents[1]} #{parents[2]}`.chomp()
    else
      # only one parent, so it is the base
      base = parents[1]
    end

    puts "\nCollecting files changed from #{base} to #{current}"

    # grab all of the files that changed between the base
    changes = `git diff-tree --no-commit-id --name-status -r #{base}..#{current}`

    # map the files into something sane for later
    changes = changes.lines.map(&:chomp).map do |line|
      status, filename = line.split("\t")
      {:status => status, :filename => filename.chomp()}
    end

    changes.select do |change|
      filename = change[:filename]
      filename.start_with?(config[:kc_doc_root]) && (filename.end_with?('.md') || filename.end_with?('.html'))
    end
  end
end
