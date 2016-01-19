
require 'spec_helper'


describe KCPreparer::Command do
  before :each do
    @config = mock('KCPreparer::Config')
    @change = mock('change')
  end

  describe "self.from_change" do
    before :each do
      @change.expects(:[]).with(:filename).returns('filename')
    end

    it 'should execute a put command on "A" status' do
      @change.expects(:[]).with(:status).returns('A')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::PutCommand')
    end

    it 'should execute a put command on "M" status' do
      @change.expects(:[]).with(:status).returns('M')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::PutCommand')
    end

    it 'should execute a delete command on "D" status' do
      @change.expects(:[]).with(:status).returns('D')
      result = KCPreparer::Command.from_change(@config, @change)
      expect(result.class.name).to eql('KCPreparer::DeleteCommand')
    end
  end
end
