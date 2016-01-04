require 'rest_client'


class KCPreparer::Nexus

  def self.publish_doc(config, doc)
    RestClient.put(self.url(config, doc), JSON.dump(doc.to_envelope), self.headers(config))
  end

  def self.delete_doc(config, doc)
    RestClient.delete(self.url(config, doc), self.headers(config))
  end

  def self.headers(config)
    auth = "deconst apikey=\"#{config[:nexus_api_key]}\""
    {:content_type => :json, :accept => :json, :Authorization => auth}
  end

  def self.url(config, doc)
    "#{config[:nexus_url]}/content/#{doc.content_id(config)}"
  end
end
