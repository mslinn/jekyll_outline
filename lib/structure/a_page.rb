# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  class APage
    def field(name)
      default_value = case sort_by
                      when :date || :last_modified || :last_modified_at
                        Date.new
                      else
                        'zzz'
                      end
      data.key?(name) ? data[name] || default_value : default_value
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
