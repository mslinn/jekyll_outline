module JekyllSupport
  FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  # Enriches JekyllSupport.APage
  class APage
    def field(name)
      data.key?(name) ? data[name] || 'zzz' : 'zzz'
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
