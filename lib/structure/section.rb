require_relative 'a_page'

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

      raise 'Section children must be APage instances' unless @children.first.instance_of?(AllCollectionsHooks::APage)

      apages = @children
               .map(&:render_outline_apage)
               .join("\n      ")

      <<~END_SECTION
        <h3 class='post_title clear' id="title_#{@order}">#{@title}</h3>
          <div id='posts_wrapper_#{@order}' class='clearfix'>
            <div id="posts_#{@order}" class='posts'>
              #{apages}
            </div>
          </div>
      END_SECTION
    end
  end
end
