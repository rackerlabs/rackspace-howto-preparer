
require 'rest_client'


class KCPreparer::Nexus

  def self.publish(config, docs)
    docs.each { |doc| KCPreparer::Nexus.publish_doc(config, doc) }
  end

  def self.publish_doc(config, doc)
    url = "#{config[:nexus_url]}/content/#{doc.content_id(config)}"
    auth = "deconst apikey=\"#{config[:nexus_api_key]}\""
    response = RestClient.put(url, JSON.dump(doc.to_envelope),
            {:content_type => :json, :accept => :json, :Authorization => auth})
  end
end
