
require 'spec_helper'


describe KCPreparer::Github do

  before(:each) do
    @slug = 'rackerlabs/rackspace-howto-dev'
    @commit = '76f4db80006b67ce34289e5a97643279d8422596'
    @config = mock('KCPreparer::Config')
    @config.stubs(:[]).with(:travis_repo_slug).returns(@slug)
    @config.stubs(:[]).with(:travis_commit).returns(@commit)
    @config.stubs(:[]).with(:github_api_token).returns('lolhax')
    @config.stubs(:[]).with(:kc_doc_root).returns('content')
  end

  describe "self.get_commit" do
    it "should get commit info from github" do
      url = "https://api.github.com/repos/#{@slug}/commits/#{@commit}"

      VCR.use_cassette('get_commit_info') do
        data = KCPreparer::Github.get_commit(@config)
        expect(data['sha']).to eql(@commit)
      end
    end
  end

  describe "self.get_file_at_sha" do
    it "should get the file contents at a specific sha" do
      filename = "content/auto-scale/general/configure-rackspace-auto-scale-web-hooks-with-cloud-monitoring.html"
      url = "https://raw.githubusercontent.com/#{@slug}/#{@commit}/#{filename}"

      VCR.use_cassette('get_file_at_sha') do
        data = KCPreparer::Github.get_file_at_sha(@config, filename, @commit)
        expect(data).to include('configure-rackspace-auto-scale-web-hooks-with-cloud-monitoring')
      end
    end
  end
end
