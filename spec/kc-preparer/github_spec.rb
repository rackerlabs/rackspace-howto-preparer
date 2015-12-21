
require 'spec_helper'


describe KCPreparer::Github do

  before(:each) do
    @config = mock('KCPreparer::Config')
  end

  describe "self.get_paths" do
    it "should get the data from github" do
      @config.stubs(:[]).with(:travis_repo_slug).returns('rackerlabs/rackspace-howto-dev')
      @config.stubs(:[]).with(:travis_commit).returns('76f4db80006b67ce34289e5a97643279d8422596')
      @config.stubs(:[]).with(:github_api_token).returns('lolhax')
      @config.stubs(:[]).with(:kc_doc_root).returns('content')

      VCR.use_cassette('get_commit_info') do
        paths = KCPreparer::Github.get_paths(@config)
        expect(paths).to include("content/auto-scale/general/configure-rackspace-auto-scale-web-hooks-with-cloud-monitoring.html")
      end
    end
  end
end
