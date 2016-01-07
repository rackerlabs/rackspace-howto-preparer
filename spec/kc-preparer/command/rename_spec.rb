
require 'spec_helper'


describe KCPreparer::RenameCommand do
  before :each do
    @path = 'permalink'
    @old_path = 'old_path'
    @config = mock('KCPreparer::Config')
    @change = mock('change')
    @document = mock('KCPreparer::Document')
    @data = 'data'

    @command = KCPreparer::RenameCommand.new(@config, @change)
  end

  describe "execute" do
    it "should delete the document from nexus" do
      @change.expects(:[]).times(2).with('filename').returns(@path)
      @change.expects(:[]).with('previous_filename').returns(@old_path)
      IO.expects(:read).with(@path).returns(@data)
      KCPreparer::Document.expects(:new).with(@config, @data).returns(@document)

      KCPreparer::Nexus.expects(:delete_doc).with(@config, @old_path)
      KCPreparer::Nexus.expects(:publish_doc).with(@config, @path, @document)

      @command.execute
    end
  end
end
