
require 'spec_helper'
require 'rest_client'


describe KCPreparer::Nexus do

  before(:each) do
    @config = mock('KCPreparer::Config')
    @document = mock('KCPreparer::Document')
  end

  describe "self.publish" do
    it "should publish data to nexus" do
      @config.expects(:[]).with(:nexus_api_key).returns('lolhax')
      @config.expects(:[]).with(:nexus_url).returns('http://192.168.99.100:9000')
      @document.expects(:content_id).with(@config).returns('%2Fpath%2Fto%2Fcontent')

      VCR.use_cassette('post_content_to_nexus') do
        @document.expects(:to_envelope).returns({"title": "Optional page title", "body": "<h1>page content</h1> <p>as raw HTML</p>"})
        KCPreparer::Nexus.publish(@config, [@document])
      end
    end
  end
end
