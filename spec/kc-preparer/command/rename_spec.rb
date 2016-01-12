
require 'spec_helper'


describe KCPreparer::RenameCommand do
  before :each do
    @config = mock('KCPreparer::Config')
    @document = mock('KCPreparer::Document')
    @path = 'permalink'
    @old_path = 'old_path'
    @data = 'data'

    @command = KCPreparer::RenameCommand.new(@config, @path, @old_path)
  end

  describe "execute" do
    it "should delete the document from nexus" do
      IO.expects(:read).with(@path).returns(@data)
      KCPreparer::Document.expects(:new).with(@config, @data).returns(@document)
      KCPreparer::Nexus.expects(:delete_doc).with(@config, @old_path)
      KCPreparer::Nexus.expects(:publish_doc).with(@config, @path, @document)

      @command.execute
    end
  end
end
