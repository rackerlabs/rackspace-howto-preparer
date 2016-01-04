require 'rest_client'


class KCPreparer::Github

  # get the files changed as part of a commit
  def self.get_commit(config)
    # grab the commit information from github
    url = "https://api.github.com/repos/#{config[:travis_repo_slug]}/commits/#{config[:travis_commit]}"
    response = self.make_request(config, url)
    JSON.parse(response.body)
  end

  # grab all of the files changed as part of the commit, and remove
  # all the ones that dont start with the specified path
  def self.get_changes(config, commit)
    commit['files'].select do |f|
      ok = true
      ok = ok && f['filename'].start_with?(config[:kc_doc_root])
      ok = ok && (f['filename'].end_with?('.md') || f['filename'].end_with?('.html'))
      ok
    end
  end

  # TODO: this probably breaks on forked commits, since the old commit is in a
  # different repo
  def self.get_file_at_sha(config, filename, sha)
    url = "https://raw.githubusercontent.com/#{config[:travis_repo_slug]}/#{sha}/#{filename}"

    begin
      response = self.make_request(config, url)
      response.body
    rescue RestClient::ResourceNotFound
      nil
    end
  end

  def self.get_url_contents(config, url)
    response = self.make_request(config, url)
    response.body
  end

  # get the contents of a file from github
  def self.make_request(config, url)
    auth = "token #{config[:github_api_token]}"
    RestClient.get(url, {:accept => :json, :Authorization => auth})
  end
end
