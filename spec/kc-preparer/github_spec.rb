
require 'spec_helper'


describe KCPreparer::Github do

  before(:each) do
    @config = mock('KCPreparer::Config')
  end

  describe "self.get_paths" do
    it "should get the data from github" do
      @config.stubs(:[]).with(:travis_repo_slug).returns('rackerlabs/docs-developer-blog')
      @config.stubs(:[]).with(:travis_commit).returns('0a71eb586823d82d05abb0e19ffd737eb54733e3')
      @config.stubs(:[]).with(:kc_root).returns('_posts')

      VCR.use_cassette('get_commit_info') do
        paths = KCPreparer::Github.get_paths(@config)
        expect(paths).to include("_posts/2015-12-03-A-First-Look-at-RBAC-in-the-Liberty-Release-of-Neutron.md")
      end
    end
  end
end
