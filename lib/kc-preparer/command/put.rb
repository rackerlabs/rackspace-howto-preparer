

class KCPreparer::PutCommand < KCPreparer::Command
  def execute
    begin
      document = KCPreparer::Document.new(@config, IO.read(@filename))
      return KCPreparer::Nexus.publish_doc(@config, @filename, document)
    rescue Exception => msg
      puts "Error with file: #{msg}"
    end
  end
end
