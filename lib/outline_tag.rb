# @author Copyright 2022 {https://www.mslinn.com Michael Slinn}

require 'jekyll_draft'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
require 'yaml'
require_relative 'jekyll_outline/version'

module OutlineTag
  PLUGIN_NAME = 'outline'.freeze

  # Interleaves with docs
  # Duck type compatible with Jekyll doc
  class Header
    attr_accessor :order, :title

    def initialize(yaml)
      @order = yaml[0]
      @published = true
      @title = yaml[1]
    end

    def to_s
      "  <h3 class='post_title clear' id=\"title_#{@order}\">#{@title}</h3>"
    end
  end

  class OutlineTag < JekyllSupport::JekyllBlock # rubocop:disable Metrics/ClassLength
    include JekyllOutlineVersion

    FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1

    def render_impl(text)
      headers = make_headers(super) # Process the block content.

      @helper.gem_file __FILE__
      @fields  = @helper.parameter_specified?('fields')&.split || ['title']
      @sort_by = @helper.parameter_specified?('sort_by_title') ? 'title' : 'order'
      @collection_name = @helper.remaining_markup
      abort 'OutlineTag: collection_name was not specified' unless @collection_name

      @docs = obtain_docs(@collection_name)
      collection = headers + @docs
      render_outline collection
    end

    # Overload this for a subclass
    def render_outline(collection)
      <<~HEREDOC
        <div class="outer_posts">
        #{make_entries collection}
        </div>
        #{@helper.attribute if @helper.attribution}
      HEREDOC
    end

    private

    def header?(variable)
      variable.instance_of?(Header)
    end

    def make_headers(content)
      yaml = YAML.safe_load(remove_leading_zeros(content))
      yaml.map { |entry| Header.new entry }
    end

    # @section_state can have values: :head, :in_body
    # @param collection Array of Jekyll::Document and Outline::Header
    # @return Array of String
    def make_entries(collection)
      sorted = if @sort_by == 'order'
                 collection.sort_by(&obtain_order)
               else
                 collection.sort_by(&obtain_field)
               end
      pruned = remove_empty_headers sorted
      @section_state = :head
      @section_id = 0
      result = pruned.map do |entry|
        handle entry
      end
      result << "    </div>\n  </div>" if @section_state == :in_body # Modify this for TOC
      result&.join("\n")
    end

    KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

    def handle(entry)
      if entry.instance_of? Header
        @header_order = entry.order
        section_end = "  </div>\n" if @section_state == :in_body
        @section_state = :head
        entry = section_end + entry.to_s if section_end
        entry
      else
        if @section_state == :head
          section_start = <<~ENDTEXT # Modify this for TOC
            <div id="posts_wrapper_#{@header_order}" class='clearfix'>
              <div id="posts_#{@header_order}" class='posts'>
          ENDTEXT
        end
        @section_state = :in_body
        date = entry.data['last_modified_at'] # "%Y-%m-%d"
        draft = Jekyll::Draft.draft_html(entry)
        visible_line = handle_entry entry
        result = "    <span>#{date}</span> <span><a href='#{entry.url}'>#{visible_line.strip}</a>#{draft}</span>" # Modify this for TOC
        result = section_start + result if section_start
        result
      end
    end

    def handle_entry(entry)
      result = ''
      @fields.each do |field|
        if KNOWN_FIELDS.include? field
          if entry.data.key? field
            result += "#{entry.data[field]} "
          else
            @logger.warn { "#{field} is a known field, but it was not present in entry #{entry}" }
          end
        else
          result += "#{field} "
        end
      end
      result
    end

    # Find the given document
    def obtain_doc(doc_name)
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @collection_name
      @site
        .collections[@collection_name]
        .docs
        .find { |doc| doc.path.end_with? "#{doc_name}.html" }
    end

    # Ignores files called index.html
    def obtain_docs(collection_name)
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @collection_name
      @site
        .collections[collection_name]
        .docs
        .reject { |doc| doc.path.end_with? 'index.html' }
    end

    # Sort entries within the outline tag which do not have the property specified by @sort_by at the end
    def obtain_field
      sort_by = @sort_by.to_s
      proc do |entry|
        if entry.respond_to? :data # page
          entry.data.key?(sort_by) ? entry.data[sort_by] || 'zzz' : 'zzz'
        else # heading
          entry.respond_to?(sort_by) ? entry.send(sort_by) || 'zzz' : 'zzz'
        end
      end
    end

    # Sort entries within the outline tag which do not have an order property at the end
    def obtain_order
      proc do |entry|
        if entry.respond_to? :data # page
          entry.data.key?('order') ? entry.data['order'] || FIXNUM_MAX : FIXNUM_MAX
        else # heading
          entry.order || FIXNUM_MAX
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

    def remove_leading_zeros(multiline)
      multiline
        .strip
        .split("\n")
        .map { |x| x.gsub(/(?<= |\A)0+(?=\d)/, '') }
        .join("\n")
    end

    JekyllPluginHelper.register(self, PLUGIN_NAME)
  end
end
