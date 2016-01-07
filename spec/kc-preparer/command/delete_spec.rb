
require 'spec_helper'


describe KCPreparer::DeleteCommand do
  before :each do
    @config = mock('KCPreparer::Config')
    @change = mock('change')
    @command = KCPreparer::DeleteCommand.new(@config, @change)
  end

  describe "execute" do
    it "should delete the document from nexus" do
      @change.expects(:[]).with('filename').returns('permalink')
      KCPreparer::Nexus.expects(:delete_doc).with(@config, 'permalink')
      @command.execute
    end
  end
end
