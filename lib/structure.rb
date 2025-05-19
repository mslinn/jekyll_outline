class OutlineError < StandardError; end

class Outline
  attr_accessor :children

  def initialize(attribute: '', attribution: false)
    @children = []
    @attribute = attribute
    @attribution = attribution
  end

  def add_child(child)
    @children << child
  end

  def to_s
    result = []
    result << "<div class='outer_posts'>"
    result << (@children.map { |x| '  ' + x.to_s })
    result << '</div>'
    result << @attribute if @attribution
    result.join "\n"
  end
end

class Section
  attr_accessor :children, :title, :order

  def initialize(title, order)
    @children = []
    @title = title
    @order = order
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
