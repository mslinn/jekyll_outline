# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1

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
