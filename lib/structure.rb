class OutlineError < StandardError; end

module JekyllSupport
  class Outline
    attr_accessor :children, :order, :title

    def initialize(yaml, attribution: '', enable_attribution: false)
      @attribution = attribution
      @children = []
      @enable_attribution = enable_attribution
      @order = yaml[0]
      # @published = true
      @title = yaml[1]
    end

    def add_child(child)
      @children << child
    end

    def to_s
      result = []
      result << "<div class='outer_posts'>"
      result << (@children.map { |x| '  ' + x.to_s })
      result << '</div>'
      result << @attribution if @enable_attribution
      result.join "\n"
    end
  end

  class Section
    attr_accessor :children, :title, :order

    def initialize(entry)
      @order, @title = entry
      @children = []
    end

    def add_child(child)
      @children << child
    end

    def to_s
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
