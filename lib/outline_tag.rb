# @author Copyright 2022 {https://www.mslinn.com Michael Slinn}

require 'jekyll_draft'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
require_relative 'jekyll_outline/version'
require_relative 'structure/outline'
require_relative 'structure/yaml_parser'

# See spec/outline_spec for an example of HTML output.
module JekyllSupport
  PLUGIN_NAME = 'outline'.freeze

  OutlineError = JekyllSupport.define_error

  class OutlineTag < JekyllBlock
    include JekyllOutlineVersion

    def render_impl(text)
      yaml_parser = YamlParser.new super # Process the block content.

      @helper.gem_file __FILE__

      @die_on_outline_error = @tag_config['die_on_outline_error'] == true if @tag_config
      @pry_on_outline_error = @tag_config['pry_on_outline_error'] == true if @tag_config

      pattern = @helper.parameter_specified?('pattern')&.split ||
                @helper.parameter_specified?('fields')&.split ||
                ['title']
      sort_by = @helper.parameter_specified?('sort_by_title') ? :title : :order
      collection_name = @helper.remaining_markup
      raise OutlineError, 'collection_name was not specified' unless collection_name

      options = Options.new(
        attribution:        @attribution,
        collection_name:    collection_name,
        enable_attribution: @attribution,
        pattern:            pattern,
        sort_by:            sort_by
      )
      outline = Outline.new(options: options)
      outline.add_sections yaml_parser.sections

      abort "#{collection_name} is not a valid collection." unless @site.collections&.key?(collection_name)
      docs = @site
             .collections[collection_name]
             .docs
      outline.add_entries collection_apages docs
      outline.to_s
    rescue OutlineError => e # jekyll_plugin_support handles StandardError
      @logger.error { JekyllPluginHelper.remove_html_tags e.logger_message }
      binding.pry if @pry_on_outline_error # rubocop:disable Lint/Debugger
      exit! 1 if @die_on_outline_error

      e.html_message
    end

    private

    # Returns an APage for each document in the collection with the given named.
    # Ignores files whose name starts with `index`,
    # and those with the following in their front matter:
    #   exclude_from_outline: true
    def collection_apages(pages)
      pages
        .reject { |doc| doc.url.match(/index(.\w*)?$/) || doc.data['exclude_from_outline'] }
        .map { |x| AllCollectionsHooks::APage.new x, 'collection' }
    end

    JekyllPluginHelper.register(self, PLUGIN_NAME)
  end
end
