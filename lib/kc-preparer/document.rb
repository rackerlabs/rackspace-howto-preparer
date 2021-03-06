require 'yaml'
require 'kramdown'
require 'erb'


class KCPreparer::Document
  attr_reader :data, :filename, :contents, :metadata

  # list of top-level envelope variables
  ENVELOPE_DATA = [
    "title"
  ]

  def initialize(config, filename, data)
    @config = config
    @filename = filename
    @data = data
    @contents = ""
    @metadata = {}

    # regex shamefully stolen from jekyll
    if (md = data.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
      parse_metadata(md[:metadata])
      parse_contents(md.post_match)
    else
      raise ArgumentError, "Document is malformed!"
    end
  end

  def to_envelope
    envelope = {}
    meta = metadata.dup

    KCPreparer::Document::ENVELOPE_DATA.each do |item|
      envelope[item] = meta.delete(item) unless meta[item].nil?
    end

    # grab the github filename
    github_url = (@filename.nil?) ? '' : File.join(@config[:kc_base_url], 'edit/master', @filename)

    # setup the metadata
    envelope['metadata'] = meta
    envelope['metadata']['github_url'] = github_url
    envelope['body'] = contents
    envelope
  end

  # parse the contents using redcarpet
  def parse_contents(data)
    @contents = Kramdown::Document.new(data, :parse_block_html => true).to_html
  end

  # parse the metadata using yaml
  def parse_metadata(metadata)
    @metadata = YAML.load(metadata) || {}
    raise ArgumentError, "Title must exist in document frontmatter" if @metadata['title'].nil?
  end
end
