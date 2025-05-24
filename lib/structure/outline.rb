require_relative 'apage'
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
    # If @sort_by == 'order' then place them into the appropriate section.
    # Otherwise place all entries into one section.
    def initialize(options: Options.new)
      @add_sections_called = false
      @options = options
      @sections = @options.sort_by == :order ? [] : [Section.new([0, ''])]
    end

    def add_entries
      entries = make_entries sort obtain_docs
      entries.each(&:add_entry)
    end

    def add_sections(sections)
      sections.each(&:add_section)
      @add_sections_called = true
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
      docs.map do |apage|
        date = apage.data['last_modified_at'] # "%Y-%m-%d"
        draft = Jekyll::Draft.draft_html apage
        Entry.new(date, apage.title, apage.url, draft)
      end
    end

    # @section_state can have values: :head, :in_body
    # @param collection Array of Jekyll::Document and JekyllSupport::Header
    # @return muliline String
    def sort(docs)
      if @options.sort_by == :order
        docs.sort_by(&obtain_order)
      else
        docs.sort_by(&obtain_field)
      end
    end

    def to_s
      return '' unless @sections&.count&.positive?

      docs = obtain_docs @options.collection_name
      make_outline docs

      result = []
      result << "<div class='outer_posts'>"
      result << (@sections.map { |section| "  #{section}" })
      result << '</div>'
      result << @options.attribution if @options.enable_attribution
      result.join "\n"
    end

    private

    def add_entry(apage)
      raise ::OutlineError, 'add_entry called without first calling add_sections' unless @add_sections_called

      section = find_section_for apage
      section.add_child apage
    end

    def add_section(section)
      return unless @options.sort_by == :order

      @sections << section
    end

    # Only called when entries are organized into multiple sections
    # @param apage must have a property called `order`
    def find_section_for(apage)
      return @sections.first if @sections.count == 1

      last = @sections.length - 1
      each 0..last do |i|
        return @sections.last if i == last

        entry_order = apage.order
        return @sections[i] if @sections[i].order >= entry_order && @sections[i + 1].order < entry_order
      end
      raise OutlineError, "No Section found for Entry #{apage}"
    end

    # Find the given document
    # def obtain_doc(doc_name)
    #   abort "#{@options.collection_name} is not a valid collection." unless @site.collections.key? @options.collection_name
    #   @site
    #     .collections[@options.collection_name]
    #     .docs
    #     .reject { |doc| doc.data['exclude_from_outline'] }
    #     .find { |doc| doc.url.match(/#{doc_name}(.\w*)?$/) }
    # end

    # Ignores files whose name starts with `index`,
    # and those with the following in their front matter:
    #   exclude_from_outline: true
    def obtain_docs
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @options.collection_name
      @site
        .collections[@collection_name]
        .docs
        .reject { |doc| doc.url.match(/index(.\w*)?$/) || doc.data['exclude_from_outline'] }
    end

    # Sort entries within the outline tag which do not have the property specified by @sort_by at the end
    def obtain_field
      sort_by = @options.sort_by.to_s
      default_value = 'zzz'
      apage.data.key?(sort_by) ? apage.data[sort_by] || default_value : default_value
    end
  end
end
