require 'jekyll_plugin_support'
require_relative 'section'

module JekyllSupport
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  class Options
    attr_accessor :attribution, :enable_attribution, :collection_name, :fields, :sort_by

    def initialize(
      collection_name: '_posts',
      attribution: '',
      enable_attribution: false,
      fields: '<b> title </b> &ndash; <i> description </i>',
      sort_by: :order
    )
      @attribution = attribution
      @enable_attribution = enable_attribution
      @collection_name = collection_name
      @fields = fields
      @sort_by = sort_by
    end
  end

  class Outline
    attr_reader :fields, :sections

    # Sort all entries first so they are iteratable according to the desired order.
    # This presorts the entries for each section.
    #
    # If options[:sort_by] == :order then place each APage into it's appropriate section.
    # Otherwise place all entries into one section.
    #
    # options[:fields] defaults to ['title'], but might be something like
    # ["<b>", "title", "</b>", "&ndash;", "<i>", "description", "</i>"]
    def initialize(options: Options.new)
      @add_sections_called = false
      @options = options
      @sections = @options.sort_by == :order ? [] : [Section.new([0, ''])]
    end

    def add_entries(apages)
      apages = make_entries sort apages
      apages.each { |x| add_apage x }
      self
    end

    def add_section(section)
      return unless @options.sort_by == :order

      @sections << section
      self
    end

    def add_sections(sections)
      sections.each { |x| add_section x }
      @add_sections_called = true
      self
    end

    # TODO: figure out how to use this
    def handle(apage)
      visible_line = handle_entry apage
      result = "    <span>#{date}</span> <span><a href='#{apage.url}'>#{visible_line.strip}</a>#{draft}</span>"
      result = section_start + result if section_start
      result
    end

    # TODO: figure out how to use this
    def handle_entry(apage)
      result = ''
      @fields.each do |field|
        if KNOWN_FIELDS.include? field
          if apage.data.key? field
            result += "#{apage.data[field]} "
          else
            @logger.warn { "#{field} is a known field, but it was not present in apage #{apage}" }
          end
        else
          result += "#{field} "
        end
      end
      result
    end

    def make_entries(docs)
      docs.map do |doc|
        draft = Jekyll::Draft.draft_html doc
        JekyllSupport.apage_from(
          date:          doc.date,
          draft:         draft,
          last_modified: doc.last_modified,
          order:         doc.order,
          title:         doc.title,
          url:           doc.url
        )
      end
    end

    # @section_state can have values: :head, :in_body
    # @param collection Array of Jekyll::Document and JekyllSupport::Header
    # @return muliline String
    def sort(docs)
      if @options.sort_by == :order
        docs.sort_by(&:order)
      else
        docs.sort_by { |doc| obtain_field doc }
      end
    end

    def to_s
      return '' unless @sections&.count&.positive?

      result = []
      result << "<div class='outer_posts'>"
      result << (@sections.map { |section| "  #{section}" })
      result << '</div>'
      result << @options[:attribution] if @options[:enable_attribution]
      result.join "\n"
    end

    private

    def add_apage(apage)
      raise ::OutlineError, 'add_apage called without first calling add_sections' unless @add_sections_called

      section = section_for apage
      section.add_child apage
    end

    # Sort entries within the outline tag which do not have the property specified by @sort_by at the end
    def obtain_field(apage)
      sort_by = @options.sort_by.to_s
      default_value = case sort_by
                      when :date, :last_modified, :last_modified_at
                        Date.today
                      else
                        ''
                      end
      if apage.data.key?(sort_by)
        apage.data[sort_by] || default_value
      else
        default_value
      end
    end

    # Only called when entries are organized into multiple sections
    # @param apage must have a property called `order`
    def section_for(apage)
      return @sections.first if @sections.count == 1

      last = @sections.length - 1
      (0..last).each do |i|
        return @sections.last if i == last

        page_order = apage.order
        this_section = @sections[i]
        next_section = @sections[i + 1]
        return this_section if (page_order >= this_section.order) && (page_order < next_section.order)
      end
      raise OutlineError, "No Section found for APage #{apage}"
    end
  end
end
