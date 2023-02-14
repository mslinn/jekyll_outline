# @author Copyright 2022 {https://www.mslinn.com Michael Slinn}

require 'jekyll_draft'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
require 'yaml'

module Outline
  PLUGIN_NAME = 'outline'.freeze

  # Interleaves with docs
  class Header
    attr_accessor :order, :title

    def initialize(yaml)
      @order = yaml[0]
      @published = true
      @title = yaml[1]
    end

    def to_s
      <<~END_STR
        <h3 id="title_#{order}">#{title}</h3>
      END_STR
    end
  end

  # Makes outlines for Jekyll pages
  class OutlineTag < JekyllSupport::JekyllBlock
    FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1

    def render_impl(text)
      @collection_name = argument_string.strip
      abort 'OutlineTag: collection_name was not specified' unless @collection_name

      headers = make_headers(super) # Process the block content.
      collection = headers + obtain_docs(@collection_name)
      <<~HEREDOC
        <div class="posts">
          #{make_entries(collection).join("\n")}
        </div>
      HEREDOC
    end

    private

    def header?(variable)
      variable.instance_of?(Header)
    end

    def make_headers(content)
      yaml = YAML.safe_load content
      yaml.map { |entry| Header.new entry }
    end

    def make_entries(collection)
      sorted = collection.sort_by(&obtain_order)
      pruned = remove_empty_headers(sorted)
      pruned.map do |entry|
        if entry.instance_of? Header
          <<~END_ENTRY
            <span></span> <span>#{entry}</span>
          END_ENTRY
        else
          date = entry.data['last_modified_at'] # "%Y-%m-%d"
          draft = Jekyll::Draft.draft_html(entry)
          <<~END_ENTRY
            <span>#{date}</span> <span><a href="#{entry.url}">#{entry.data['title']}</a>#{draft}</span>
          END_ENTRY
        end
      end
    end

    # Ignores files called index.html
    def obtain_docs(collection_name)
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @collection_name
      @site
        .collections[collection_name]
        .docs
        .reject { |doc| doc.path.end_with? 'index.html' }
    end

    # Sort entries without an order property at the end
    def obtain_order
      proc do |entry|
        if entry.respond_to? :data
          entry.data.key?('order') ? entry.data['order'] : FIXNUM_MAX
        else
          entry.order
        end
      end
    end

    def remove_empty_headers(array)
      i = 0
      while i < array.length - 1
        if header?(array[i]) && header?(array[i + 1])
          array.delete_at(i)
        else
          i += 1
        end
      end

      array.delete_at(array.length - 1) if header?(array.last)
      array
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{Outline::PLUGIN_NAME} v#{JekyllOutlineVersion::VERSION} plugin." }
Liquid::Template.register_tag(Outline::PLUGIN_NAME, Outline::OutlineTag)
