
require 'spec_helper'


describe KCPreparer::PutCommand do
  before :each do
    @path = 'permalink'
    @config = mock('KCPreparer::Config')
    @change = mock('change')
    @document = mock('KCPreparer::Document')
    @data = 'data'

    @command = KCPreparer::PutCommand.new(@config, @change)
  end

  describe "execute" do
    it "should update the document in nexus" do
      @change.expects(:[]).times(2).with('filename').returns(@path)
      IO.expects(:read).with(@path).returns(@data)
      KCPreparer::Document.expects(:new).with(@config, @data).returns(@document)
      KCPreparer::Nexus.expects(:publish_doc).with(@config, @path, @document)

      @command.execute
    end
  end
end
