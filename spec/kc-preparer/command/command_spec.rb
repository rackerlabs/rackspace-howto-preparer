
require 'spec_helper'


describe KCPreparer::Command do
  before :each do
    @config = mock('KCPreparer::Config')
    @change = mock('change')
  end

  describe "self.from_change" do
    it 'should execute a put command on "added"' do
      @change.expects(:[]).with('status').returns('added')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::PutCommand')
    end

    it 'should execute a put command on "changed"' do
      @change.expects(:[]).with('status').returns('changed')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::PutCommand')
    end

    it 'should execute a put command on "modified"' do
      @change.expects(:[]).with('status').returns('modified')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::PutCommand')
    end

    it 'should execute a delete command on "removed"' do
      @change.expects(:[]).with('status').returns('removed')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::DeleteCommand')
    end

    it 'should execute a rename command on "renamed"' do
      @change.expects(:[]).with('status').returns('renamed')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::RenameCommand')
    end
  end
end
