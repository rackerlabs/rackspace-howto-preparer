
require 'spec_helper'


describe KCPreparer::Config do

  before(:each) do
    @vars = []
  end

  after(:each) do
    @vars.each { |var| ENV.delete(var) }
  end

  describe "initialize" do
    it "should setup partial runs properly" do
      add_vars(KCPreparer::Config::GENERAL_VARS + KCPreparer::Config::TRAVIS_VARS)
      config = KCPreparer::Config.new([])
      expect(config[:full]).to be(false)
    end

    it "should setup full runs properly" do
      add_vars(KCPreparer::Config::GENERAL_VARS)
      config = KCPreparer::Config.new(['--full'])
      expect(config[:full]).to be(true)
    end

    it "should add the proper general env variables to the config" do
      add_vars(KCPreparer::Config::GENERAL_VARS + KCPreparer::Config::TRAVIS_VARS)
      config = KCPreparer::Config.new([])

      (KCPreparer::Config::GENERAL_VARS + KCPreparer::Config::TRAVIS_VARS).each do |var|
        expect(config[var.downcase.to_sym]).to eq(var)
      end
    end

    it "should error on a missing env variable" do
      ENV.delete('NEXUS_API_KEY')
      expect {KCPreparer::Config.new([])}.to raise_exception(ArgumentError)
    end

    it "should ignore travis keys when doing a full run" do
      add_vars(KCPreparer::Config::GENERAL_VARS + KCPreparer::Config::TRAVIS_VARS)
      config = KCPreparer::Config.new(['--full'])

      KCPreparer::Config::GENERAL_VARS.each do |var|
        expect(config[var.downcase.to_sym]).to eq(var)
      end

      KCPreparer::Config::TRAVIS_VARS.each do |var|
        expect(config[var.downcase.to_sym]).to be_nil
      end
    end
  end

  def add_vars(vars)
    vars.each do |var|
      ENV[var] = var
      @vars << var
    end
  end
end
