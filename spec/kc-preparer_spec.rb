
require 'spec_helper'


describe KCPreparer do
  describe "self.main" do

    before(:each) do
      @argv = []
      @config = mock('KCPreparer::Config')
      KCPreparer::Config.expects(:new).with(@argv).returns(@config)
      KCPreparer::Directory.stubs(:get_paths).returns([])
      KCPreparer::Github.stubs(:get_paths).returns([])
      KCPreparer::Document.stubs(:new)
      KCPreparer::Nexus.stubs(:publish)
    end

    it "should pass ARGV to the config object" do
      @config.stubs(:[]).with(:full).returns(false)
      KCPreparer.main(@argv)
    end

    it "should call the directory object to get all the files" do
      @config.stubs(:[]).with(:full).returns(true)
      KCPreparer::Directory.expects(:get_paths).returns([])
      KCPreparer::Github.expects(:get_paths).never
      KCPreparer.main(@argv)
    end

    it "should call the github object to get the files from the last commit" do
      @config.stubs(:[]).with(:full).returns(false)
      KCPreparer::Directory.expects(:get_paths).never
      KCPreparer::Github.expects(:get_paths).returns([])
      KCPreparer.main(@argv)
    end

    it "should prep the documents from the paths" do
      paths = ['foo', 'bar']
      @config.stubs(:[]).with(:full).returns(true)
      KCPreparer::Directory.stubs(:get_paths).returns(paths)

      paths.each do |path|
        KCPreparer::Document.expects(:new).with(@config, path).returns(mock())
      end

      KCPreparer.main(@argv)
    end

    it "should publish the documents to nexus" do
      path = 'foo'
      doc = mock('KCPreparer::Document')

      @config.stubs(:[]).with(:full).returns(true)
      KCPreparer::Directory.stubs(:get_paths).returns([path])
      KCPreparer::Document.stubs(:new).with(@config, path).returns(doc)
      KCPreparer::Nexus.expects(:publish).with(@config, [doc])

      KCPreparer.main(@argv)
    end
  end
end
