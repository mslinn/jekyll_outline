# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  # Overrides definition from `jekyll_plugin_support`
  class APage
    # @param name can be either a String or a Symbol
    def field(name)
      default_value = case name
                      when :date, :last_modified, :last_modified_at
                        AllCollectionsHooks::END_OF_DAYS
                      else
                        ''
                      end
      if data.key?(name.to_sym) || data.key?(name.to_s)
        data[name.to_sym] || data[name.to_s] || default_value
      else
        default_value
      end
    end

    def render_outline_apage
      <<~END_ENTRY
        <span>#{@date.strftime('%Y-%m-%d')}</span>
              <span><a href='#{@url}'>#{@title}</a>#{@draft}</span>
      END_ENTRY
    end
  end
end
