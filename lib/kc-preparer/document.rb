
require 'yaml'
require 'redcarpet'
require 'erb'


class KCPreparer::Document
  attr_reader :path, :contents, :metadata

  # list of top-level envelope variables
  ENVELOPE_DATA = [
    "title",
    "permalink"
  ]

  def initialize(config, path)
    @config = config
    @path = path
    @contents = ""
    @metadata = {}
  end

  # parse the file into it's constituent parts
  def parse
    # regex shamefully stolen from jekyll
    if (md = IO.read(path).match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
      parse_metadata(md[:metadata])
      parse_contents(md.post_match) unless @metadata['html']
    else
      raise ArgumentError, "Document at path #{path} is malformed!"
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
    ERB::Util.url_encode(config[:kc_base_url] + metadata['permalink'])
  end

  # turn a set of paths into documents
  def self.from_paths(config, paths)
    docs = paths.map { |path| KCPreparer::Document.new(config, path) }
    docs.each { |doc| doc.parse }
    docs
  end

  # parse the contents using redcarpet
  def parse_contents(contents)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @contents = markdown.render(contents)
  end

  # parse the metadata using yaml
  def parse_metadata(metadata)
    @metadata = YAML.load(metadata) || {}
    raise ArgumentError, "Title must exist in document frontmatter for #{path}" if @metadata['title'].nil?
    raise ArgumentError, "Permalink must exist in document frontmatter for #{path}" if @metadata['permalink'].nil?
  end
end
