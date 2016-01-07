
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

  describe "self.get_changes" do
    it "should return the applicable changes" do
      url = "https://api.github.com/repos/#{@slug}/commits/#{@commit}"

      VCR.use_cassette('get_commit_info') do
        data = KCPreparer::Github.get_commit(@config)
        changes = KCPreparer::Github.get_changes(@config, data)
        files = changes.map { |change| change['filename'] }
        expect(files).to include('content/cloud-hosting/undefined/mobile-commerce-on-the-hybrid-cloud.html')
      end
    end
  end
end
