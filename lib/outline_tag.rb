# @author Copyright 2022 {https://www.mslinn.com Michael Slinn}

require 'jekyll_draft'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
require_relative 'jekyll_outline/version'

# See spec/outline_spec for an example of HTML output.
module JekyllSupport
  PLUGIN_NAME = 'outline'.freeze

  OutlineError = JekyllSupport.define_error

  class OutlineTag < JekyllBlock
    include JekyllOutlineVersion

    def render_impl(text)
      @yaml_parser = YamlParser.new super # Process the block content.

      @helper.gem_file __FILE__

      @die_on_outline_error = @tag_config['die_on_outline_error'] == true if @tag_config
      @pry_on_outline_error = @tag_config['pry_on_outline_error'] == true if @tag_config

      @fields  = @helper.parameter_specified?('fields')&.split || ['title']
      @sort_by = @helper.parameter_specified?('sort_by_title') ? 'title' : 'order'
      @collection_name = @helper.remaining_markup
      raise OutlineError, 'collection_name was not specified' unless @collection_name

      @docs = obtain_docs(@collection_name)
      render_outline @headers, @docs
    rescue OutlineError => e # jekyll_plugin_support handles StandardError
      @logger.error { JekyllPluginHelper.remove_html_tags e.logger_message }
      binding.pry if @pry_on_outline_error # rubocop:disable Lint/Debugger
      exit! 1 if @die_on_outline_error

      e.html_message
    end

    def render_outline(collection)
      outline = Outline.new
      make_outline collection, outline
      outline.to_s
    end

    JekyllPluginHelper.register(self, PLUGIN_NAME)
  end
end
