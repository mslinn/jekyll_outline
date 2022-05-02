# frozen_string_literal: true

# @author Copyright 2022 {https://www.mslinn.com Michael Slinn}

require "jekyll_draft"
require "jekyll_plugin_logger"
require 'yaml'

module Outline
  PLUGIN_NAME = "outline"

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
  class OutlineTag < Liquid::Block
    FIXNUM_MAX = 2**(0.size * 8 - 2) - 1

    # Called by Jekyll only once to register the tag.
    # @param tag_name [String] is the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the web page.
    # @param _parse_context [Liquid::ParseContext] hash that stores Liquid options.
    #        By default it has two keys: :locale and :line_numbers, the first is a Liquid::I18n object, and the second,
    #        a boolean parameter that determines if error messages should display the line number the error occurred.
    #        This argument is used mostly to display localized error messages on Liquid built-in Tags and Filters.
    #        See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
    # @return [void]
    def initialize(tag_name, argument_string, _parse_context)
      super
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
      @collection_name = argument_string.strip
      abort "OutlineTag: collection_name was not specified" unless @collection_name
    end

    # Method prescribed by the Jekyll plugin lifecycle.
    # @param liquid_context [Liquid::Context]
    # @return [String]
    def render(liquid_context)
      headers = make_headers(super) # Process the block content.
      @site = liquid_context.registers[:site]
      collection = headers + obtain_docs(@collection_name)
      <<~HEREDOC
        <ol class="outline">
          #{make_entries(collection).join("\n")}
        </ol>
      HEREDOC
    end

    private

    def make_headers(content)
      yaml = YAML.safe_load content
      yaml.map { |entry| Header.new entry }
    end

    def make_entries(collection) # rubocop:disable Metrics/MethodLength
      sorted = collection.sort_by(&obtain_order)
      sorted.map do |entry|
        if entry.instance_of? Header
          entry.to_s
        else
          date = entry.data['last_modified_at'] # "%Y-%m-%d"
          <<~END_ENTRY
            <li>#{date} &nbsp; <a href="#{entry.url}">#{entry.data['title']}</a>#{Draft.draft_html(entry)}</li>
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
        .reject { |doc| doc.path.end_with? "index.html" }
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
  end
end

# PluginMetaLogger.instance.info { "Loaded #{JekyllPluginTagTemplate::PLUGIN_NAME} v#{JekyllPluginTemplateVersion::VERSION} plugin." }
PluginMetaLogger.instance.info { "Loaded Outline plugin." }
Liquid::Template.register_tag(Outline::PLUGIN_NAME, Outline::OutlineTag)
