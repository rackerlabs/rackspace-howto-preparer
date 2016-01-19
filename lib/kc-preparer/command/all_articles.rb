
require 'csv'
require 'erb'


class KCPreparer::AllArticlesCommand < KCPreparer::Command

  # Handle the special case of the article pages
  def execute
    CSV.foreach(@filename, :headers => true) do |row|
      create_page(row) unless row['Product Name'].nil? || row['Category'].nil?
    end
  end

  def create_page(row)
    paths = Dir.glob(File.join(Dir.pwd, config[:kc_doc_root], '**', row['Directory'], '*.{md,html}'))
    permalinks = get_permalinks(paths)
    data = generate_file(row, permalinks)
    KCPreparer::Nexus.publish_doc(@config, "#{row['Directory']}-all-articles", data)
  end

  def get_permalinks(paths)
    paths.map do |path|
      link = '/how-to/' + File.basename(path, '.*')
      document = KCPreparer::Document.new(@config, path, IO.read(path))
      {'link' => link, 'title' => document.metadata['title']}
    end
  end

  def generate_file(row, permalinks)
    template = KCPreparer::AllArticlesCommand::Template.new(row, permalinks)
    KCPreparer::Document.new(@config, nil, template.render)
  end

  class Template
    include ERB::Util
    attr_accessor :product_name, :category, :permalinks

    def initialize(row, permalinks)
      @product_name = row['Product Name']
      @category = row['Category']
      @permalinks = permalinks
    end

    def render()
      ERB.new(ALL_ARTICLE_TEMPLATE).result(binding)
    end
  end
end


ALL_ARTICLE_TEMPLATE = <<-END
---
title: <%= @product_name %> - All Articles
category: <%= @category %>
---

<div class="article-list">
<% for @link in @permalinks %>
<div class="article-entry">
<h4><a href="<%= @link['link'] %>"><%= @link['title'] %></a></h4>
</div>
<% end %>
</div>
END
