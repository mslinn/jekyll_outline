module JekyllSupport
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
      return '' if @children.count.zero?

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
end
