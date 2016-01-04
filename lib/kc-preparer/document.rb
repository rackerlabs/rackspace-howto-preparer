require 'yaml'
require 'redcarpet'
require 'erb'


class KCPreparer::Document
  attr_reader :data, :contents, :metadata

  # list of top-level envelope variables
  ENVELOPE_DATA = [
    "title",
    "permalink"
  ]

  def initialize(config, data)
    @config = config
    @data = data
    @contents = ""
    @metadata = {}

    # regex shamefully stolen from jekyll
    if (md = data.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
      parse_metadata(md[:metadata])
      parse_contents(md.post_match) unless @metadata['html']
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

    envelope['metadata'] = meta
    envelope['body'] = contents
    envelope
  end

  def content_id(config)
    ERB::Util.url_encode(config[:kc_base_url] + '/' + metadata['permalink'])
  end

  # parse the contents using redcarpet
  def parse_contents(contents)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @contents = markdown.render(contents)
  end

  # parse the metadata using yaml
  def parse_metadata(metadata)
    @metadata = YAML.load(metadata) || {}
    raise ArgumentError, "Title must exist in document frontmatter" if @metadata['title'].nil?
    raise ArgumentError, "Permalink must exist in document frontmatter" if @metadata['permalink'].nil?
  end
end
