module JekyllSupport
  FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  class OutlineTag
    # TODO: figure out how to use this
    def handle(entry)
      visible_line = handle_entry entry
      result = "    <span>#{date}</span> <span><a href='#{entry.url}'>#{visible_line.strip}</a>#{draft}</span>"
      result = section_start + result if section_start
      result
    end

    # TODO: figure out how to use this
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

    # @section_state can have values: :head, :in_body
    # @param collection Array of Jekyll::Document and JekyllSupport::Header
    # @return muliline String
    def make_outline(collection)
      sorted = if @sort_by == 'order'
                 collection.sort_by(&obtain_order)
               else
                 collection.sort_by(&obtain_field)
               end
      pruned = remove_empty_headers sorted
      outline = Outline.new
      pruned.map do |entry|
        if entry.instance_of? Header
          @section = Section.new [entry.order, entry.title]
          outline.add_child @section
        else
          date = entry.data['last_modified_at'] # "%Y-%m-%d"
          draft = Jekyll::Draft.draft_html entry
          @section.add_child Entry.new(date, entry.title, entry.url, draft)
        end
      end
      outline
    end

    # Find the given document
    def obtain_doc(doc_name)
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @collection_name
      @site
        .collections[@collection_name]
        .docs
        .reject { |doc| doc.data['exclude_from_outline'] }
        .find { |doc| doc.url.match(/#{doc_name}(.\w*)?$/) }
    end

    # Ignores files whose name starts with `index`, and those with the following in their front matter:
    # exclude_from_outline: true
    def obtain_docs(collection_name)
      abort "#{@collection_name} is not a valid collection." unless @site.collections.key? @collection_name
      @site
        .collections[collection_name]
        .docs
        .reject { |doc| doc.url.match(/index(.\w*)?$/) || doc.data['exclude_from_outline'] }
    end
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
end
