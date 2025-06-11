require_relative 'a_page_enrichment'

module JekyllSupport
  class Section
    attr_accessor :children, :title, :order

    def initialize(outline_options, parameter_array)
      @outline_options = outline_options
      @order = parameter_array[0].to_i
      @title = parameter_array[1]
      @children = []
    end

    def add_child(child)
      @children << child
    end

    def to_s
      return '' if @children.count.zero?

      unless @children.first.instance_of?(JekyllSupport::APage)
        raise "First child of Section was a #{@children.first.class}, not an APage"
      end
      apages = @children
               .map { |x| x.render_outline_apage @outline_options.pattern }
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
