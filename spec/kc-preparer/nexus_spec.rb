
require 'spec_helper'
require 'rest_client'


describe KCPreparer::Nexus do

  before(:each) do
    @config = mock('KCPreparer::Config')
    @document = mock('KCPreparer::Document')
    @path = '/path/to/content.md'
  end

  describe "self.publish_doc" do
    it "should publish data to nexus" do
      @config.expects(:[]).with(:nexus_api_key).returns('lolhax')
      @config.expects(:[]).with(:nexus_url).returns('http://192.168.99.100:9000')
      @config.expects(:[]).with(:kc_base_url).returns('')

      VCR.use_cassette('post_content_to_nexus') do
        @document.expects(:to_envelope).returns({
          "title": "Optional page title",
          "body": "<h1>page content</h1> <p>as raw HTML</p>"
        })

        KCPreparer::Nexus.publish_doc(@config, @path, @document)
      end
    end
  end

  describe "self.delete_doc" do
    it "should delete data from nexus" do
      @config.expects(:[]).with(:nexus_api_key).returns('lolhax')
      @config.expects(:[]).with(:nexus_url).returns('http://192.168.99.100:9000')
      @config.expects(:[]).with(:kc_base_url).returns('')

      VCR.use_cassette('delete_content_from_nexus') do
        KCPreparer::Nexus.delete_doc(@config, @path)
      end
    end
  end

  describe "self.url" do
    before :each do
      @config.expects(:[]).with(:nexus_url).returns('nexus_url')
      @config.expects(:[]).with(:kc_base_url).returns('base_url')
    end

    it "should add the filename to the base_url" do
      result = KCPreparer::Nexus.url(@config, 'filename')
      expect(result).to include('nexus_url')
      expect(result).to include('base_url')
      expect(result).to include('filename')
    end

    it "should not add anything if the filename is blank" do
      result = KCPreparer::Nexus.url(@config, '')
      expect(result).to include('nexus_url')
      expect(result).to include('base_url')
      expect(result).not_to include('%2F')
    end

    it "should urlencode the path given" do
      result = KCPreparer::Nexus.url(@config, 'filename')
      expect(result).to include('%2F')
    end
  end
end
