
require 'rest_client'


class KCPreparer::Github

  # get the files changed as part of a commit
  def self.get_paths(config)
    # grab the commit information from github
    url = "https://api.github.com/repos/#{config[:travis_repo_slug]}/commits/#{config[:travis_commit]}"
    response = RestClient.get(url, {:accept => :json})
    data = JSON.parse(response.body)

    # grab all of the files changed as part of the commit, and remove
    # all the ones that dont start with the specified path
    files = data['files'].map { |i| i['filename'] }

    files.select do |fname|
        ok = true
        ok = ok && fname.start_with?(config[:kc_root])
        ok = ok && (fname.end_with?('.md') || fname.end_with?('.html'))
        ok
    end
  end
end
