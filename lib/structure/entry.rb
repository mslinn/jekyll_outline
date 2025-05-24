module JekyllSupport
  FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  class Entry
    attr_accessor :data, :date, :draft, :title, :url

    def initialize(date, order, title, url, draft: nil)
      @date = date
      @draft = "<i class='jekyll_draft'>Draft</i>" if draft
      @order = order
      @title = title
      @url = url
    end

    def field(sort_by)
      data.key?(sort_by) ? data[sort_by] || 'zzz' : 'zzz'
    end

    def order
      data.key?('order') ? data['order'] || FIXNUM_MAX : FIXNUM_MAX
    end

    def to_s
      <<~END_ENTRY
        <span>#{@date}</span>
              <span><a href='#{@url}'>#{@title}</a>#{@draft}</span>
      END_ENTRY
    end
  end
end
