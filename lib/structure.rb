class OutlineError < StandardError; end

module JekyllSupport
  class Outline
    attr_reader :fields, :sections

    def initialize(
      attribution: '',
      enable_attribution: false,
      fields: '<b> title </b> &ndash; <i> description </i>',
      sort_by: :order
    )
      @attribution = attribution
      @enable_attribution = enable_attribution
      @fields = fields
      @sections = []
      @sort_by = sort_by
    end

    def add_section(section)
      @sections << section
    end

    def to_s
      return unless @sections&.count&.positive?

      result = []
      result << "<div class='outer_posts'>"
      result << (@sections.map { |section| "  #{section}" })
      result << '</div>'
      result << @attribution if @enable_attribution
      result.join "\n"
    end
  end

  class Section
    attr_accessor :children, :title, :order

    def initialize(entry)
      @order = entry.first.to_i
      @title = entry[1]
      @children = []
    end

    def add_child(child)
      @children << child
    end

    def to_s
      return if @children.count.zero?

      <<~END_SECTION
        <h3 class='post_title clear' id="title_#{@order}">#{@title}</h3>
          <div id='posts_wrapper_#{@order}' class='clearfix'>
            <div id="posts_#{@order}" class='posts'>
              #{@children.map(&:to_s).join("\n      ")}
            </div>
          </div>
      END_SECTION
    end
  end

  class Entry
    attr_accessor :date, :draft, :title, :url

    def initialize(date, title, url, draft: nil)
      @date = date
      @draft = "<i class='jekyll_draft'>Draft</i>" if draft
      @title = title
      @url = url
    end

    def to_s
      <<~END_ENTRY
        <span>#{@date}</span>
              <span><a href='#{@url}'>#{@title}</a>#{@draft}</span>
      END_ENTRY
    end
  end
end
