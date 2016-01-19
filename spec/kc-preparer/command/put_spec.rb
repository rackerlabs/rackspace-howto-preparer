
require 'spec_helper'


describe KCPreparer::PutCommand do
  before :each do
    @config = mock('KCPreparer::Config')
    @document = mock('KCPreparer::Document')
    @path = 'permalink'
    @data = 'data'

    @command = KCPreparer::PutCommand.new(@config, @path)
  end

  describe "execute" do
    it "should update the document in nexus" do
      IO.expects(:read).with(@path).returns(@data)
      KCPreparer::Document.expects(:new).with(@config, @path, @data).returns(@document)
      KCPreparer::Nexus.expects(:publish_doc).with(@config, @path, @document)
      @command.execute
    end
  end
end
