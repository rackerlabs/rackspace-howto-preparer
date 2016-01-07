require 'rest_client'


class KCPreparer::Nexus

  def self.publish_doc(config, path, doc)
    RestClient.put(self.url(config, path), JSON.dump(doc.to_envelope), self.headers(config))
  end

  def self.delete_doc(config, path)
    RestClient.delete(self.url(config, path), self.headers(config))
  end

  def self.headers(config)
    auth = "deconst apikey=\"#{config[:nexus_api_key]}\""
    {:content_type => :json, :accept => :json, :Authorization => auth}
  end

  def self.url(config, path)
    permalink = File.basename(path, '.*')
    content_id = ERB::Util.url_encode(config[:kc_base_url] + '/' + permalink)
    "#{config[:nexus_url]}/content/#{content_id}"
  end
end
