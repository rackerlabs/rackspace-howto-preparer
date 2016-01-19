
require 'spec_helper'


describe KCPreparer::IndexCommand do
  before :each do
    @config = mock('KCPreparer::Config')
    @document = mock('KCPreparer::Document')
    @path = 'path/to/index.md'
    @data = 'data'

    @command = KCPreparer::IndexCommand.new(@config, @path)
  end

  describe "execute" do
    it "should update the document in nexus" do
      IO.expects(:read).with(@path).returns(@data)
      KCPreparer::Document.expects(:new).with(@config, @path, @data).returns(@document)
      KCPreparer::Nexus.expects(:publish_doc).with(@config, "", @document)
      @command.execute
    end
  end
end
