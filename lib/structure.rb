class OutlineError < StandardError; end

class Outline
  attr_accessor :children

  def initialize
    @children = []
  end

  def add_child(child)
    @children << child
  end

  def to_s
    result = []
    result += "<div class='outer_posts'>"
    result += '  ' + @children.map(&:to_s)
    result += '</div>'
    result += @helper.attribute.to_s if @helper.attribution
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
      <h3 class='post_title clear' id="title_#{@order}">@title</h3>
      <div id='posts_wrapper_#{@order}' class='clearfix'>
        <div id="posts_#{@order}" class='posts'>
          #{@children.map(&:to_s).join("\n")}
        </div>
      </div>
    END_SECTION
  end
end

class Entry
  attr_accessor :date, :draft, :title, :url

  def initialize(date, draft, title, url)
    @date = date
    @draft = draft
    @title = title
    @url = url
  end

  def to_s
    <<~END_ENTRY
      <span>#{@date}</span>
      <span>
      	<a href='#{@url}'>#{@title}</a>#{@draft}
      </span>
    END_ENTRY
  end
end
