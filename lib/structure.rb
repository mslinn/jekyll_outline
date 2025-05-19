class OutlineError < StandardError; end

class Outline
  attr_accessor :name, :children

  def initialize
    @children = []
  end

  def add_child(child)
    @children << child
  end

  def to_s
    result = "<div class='outer_posts'>\n"
    @children.each do |child|
      result += child.to_s
    end
    result += <<~END_END
      </div>
      #{@helper.attribute if @helper.attribution}
    END_END
    result.join "\n"
  end
end

class Section
  attr_accessor :children, :title, :order, :url

  def initialize(title, order, url)
    @children = []
    @title = title
    @order = order
    @url = url
  end

  def add_child(child)
    @children << child
  end

  def to_s
    <<~END_END
      <div id='posts_wrapper_#{@header_order}' class='clearfix'>
      <div id="posts_#{@header_order}" class='posts'>
        #{@children}
      </div>
    END_END
  end
end

class Entry
  attr_accessor :date, :draft, :last_modified_at, :order, :title, :url

  def initialize(title, order, url)
    @title = title
    @order = order
    @url = url
  end

  def to_s
    <<~END_END
      <div class='entry'>
        <h2><a href='#{@url}'>#{@title}</a></h2>
      </div>
    END_END
  end
end

# Example usage:
outline = Outline.new
outline.add_child(Header.new('Title 1', 1, 'url1'))
outline.add_child(Header.new('Title 2', 2, 'url2'))
puts outline
