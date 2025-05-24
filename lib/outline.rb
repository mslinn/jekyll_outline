module JekyllSupport
  class OutlineTag
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
          @section = Section.new entry.order, entry.title
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
end
