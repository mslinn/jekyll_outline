# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  class APage
    def field(name)
      data.key?(name) ? data[name] || 'zzz' : 'zzz'
    end

    # Overrides `to_s` defined in `jekyll_plugin_support`
    def outline_entry
      <<~END_ENTRY
        <span>#{@date}</span>
              <span><a href='#{@url}'>#{@title}</a>#{@draft}</span>
      END_ENTRY
    end
  end
end
