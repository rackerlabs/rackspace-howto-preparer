
require 'yaml'
require 'redcarpet'
require 'erb'


class KCPreparer::Document
  attr_reader :path, :contents, :metadata

  # list of top-level envelope variables, taken from:
  # https://github.com/deconst/preparer-jekyll/blob/master/lib/preparermd/plugins/metadata_envelopes.rb
  ENVELOPE_DATA = [
    "title",
    "permalink",
    "content_type",
    "author",
    "bio",
    "publish_date",
    "next",
    "previous",
    "queries",
    "tags"
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
    metadata = self.metadata.dup

    # handle the 80% cases
    KCPreparer::Document::ENVELOPE_DATA.each do |item|
      envelope[item] = metadata.delete(item) unless metadata[item].nil?
    end

    # add a default for categories
    envelope['categories'] == [] if envelope['categories'].nil?

    # dedup the tags
    envelope['tags'] = Set.new(envelope['tags'] || []).to_a

    # add the metadata
    envelope['meta'] = metadata

    # add the body
    envelope['body'] = self.contents

    envelope
  end

  def content_id(config)
    ERB::Util.url_encode(config[:kc_base_url] + metadata['permalink'])
  end

  # turn a set of paths into documents
  def self.from_paths(config, paths)
    paths.map { |path| KCPreparer::Document.new(config, path) }
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
