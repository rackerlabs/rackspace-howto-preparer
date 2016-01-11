
require 'spec_helper'


describe KCPreparer::DeleteCommand do
  before :each do
    @config = mock('KCPreparer::Config')
    @filename = 'filename'
    @command = KCPreparer::DeleteCommand.new(@config, @filename)
  end

  describe "execute" do
    it "should delete the document from nexus" do
      KCPreparer::Nexus.expects(:delete_doc).with(@config, @filename)
      @command.execute
    end
  end
end
