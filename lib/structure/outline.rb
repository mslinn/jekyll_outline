require 'jekyll_plugin_support'
require_relative 'section'

module JekyllSupport
  # @param attribution sets the attribution message
  # @param enable_attribution causes the attribution message to be displayed if truthy
  # @param collection_name Name of the Jekyll collection the outline is organizing
  # @param pattern String containing keyswords and literals; interpreted and displayed when an APage is rendered as a topic entry
  # @param sort_by Either has value :order or :title
  class OutlineOptions
    attr_accessor :attribution, :enable_attribution, :collection_name, :pattern, :sort_by

    def initialize(
      collection_name: '_posts',
      attribution: '',
      enable_attribution: false,
      pattern: '<b> title </b> &ndash; <i> description </i>',
      sort_by: :order
    )
      @attribution = attribution
      @enable_attribution = enable_attribution
      @collection_name = collection_name
      @pattern = pattern
      @sort_by = sort_by
    end
  end

  class Outline
    attr_reader :options, :sections

    # Sort all entries first so they are iteratable according to the desired order.
    # This presorts the entries for each section.
    #
    # If options[:sort_by] == :order then place each APage into it's appropriate section.
    # Otherwise place all entries into one section.
    #
    # options[:pattern] defaults to ['title'], but might be something like
    # ["<b>", "title", "</b>", "&ndash;", "<i>", "description", "</i>"]
    def initialize(outline_options: OutlineOptions.new)
      @add_sections_called = false
      @options = outline_options
      @sections = @options.sort_by == :order ? [] : [Section.new(@options, [0, ''])]
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

    # @param apages [APage]
    # @return muliline String
    def sort(apages)
      if @options.sort_by == :order
        apages.sort_by(&:order)
      else
        apages.sort_by { |apage| sort_property_value apage }
      end
    end

    def to_s
      return '' unless @sections&.count&.positive?

      result = []
      result << "<div class='outer_posts'>"
      result << (@sections.map { |section| "  #{section}" })
      result << '</div>'
      result << @options.attribution if @options.enable_attribution
      result.join "\n"
    end

    private

    def add_apage(apage)
      raise ::OutlineError, 'add_apage called without first calling add_sections' unless @add_sections_called

      section = section_for apage
      section.add_child apage
    end

    def default_sort_value(sort_by)
      case sort_by
      when :date, :last_modified, :last_modified_at
        Date.today
      else
        ''
      end
    end

    # Obtain sort property value from APage instance, or return a default value
    def sort_property_value(apage)
      sort_by = @options.sort_by.to_s
      if apage.data.key?(sort_by)
        apage.data[sort_by] || default_sort_value(sort_by)
      else
        default_sort_value(sort_by)
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
