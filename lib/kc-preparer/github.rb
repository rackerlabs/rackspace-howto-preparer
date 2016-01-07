require 'rest_client'


class KCPreparer::Github

  # get the files changed as part of a commit
  def self.get_commit(config)
    # grab the commit information from github
    url = "https://api.github.com/repos/#{config[:travis_repo_slug]}/commits/#{config[:travis_commit]}"
    auth = "token #{config[:github_api_token]}"
    response = RestClient.get(url, {:accept => :json, :Authorization => auth})
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
end
