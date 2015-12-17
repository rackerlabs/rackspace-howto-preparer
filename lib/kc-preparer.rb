

class KCPreparer

  # application entry point
  def self.main(argv)
    config = KCPreparer::Config.new(argv)
    paths = self.get_paths(config)
    documents = KCPreparer::Document.from_paths(config, paths)
    KCPreparer::Nexus.publish(config, documents)
  end

  # get the file paths we need to update
  def self.get_paths(config)
    if config[:full]
      KCPreparer::Directory.get_paths(config)
    else
      KCPreparer::Github.get_paths(config)
    end
  end
end

require 'kc-preparer/config'
require 'kc-preparer/directory'
require 'kc-preparer/document'
require 'kc-preparer/github'
require 'kc-preparer/nexus'
