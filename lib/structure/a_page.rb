# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  # Overrides definition from `jekyll_plugin_support`
  class APage
    # @param name can be either a String or a Symbol
    def field(name)
      default_value = case name
                      when :date, :last_modified, :last_modified_at
                        AllCollectionsHooks::END_OF_TIME
                      else
                        ''
                      end
      if data.key?(name.to_sym) || data.key?(name.to_s)
        data[name.to_sym] || data[name.to_s] || default_value
      else
        default_value
      end
    end

    # TODO: figure out how to use this
    def handle(apage)
      visible_line = handle_entry apage
      result = "    <span>#{date}</span> <span><a href='#{apage.url}'>#{visible_line.strip}</a>#{draft}</span>"
      result = section_start + result if section_start
      result
    end

    # TODO: figure out how to use this
    def handle_entry(apage)
      result = ''
      @pattern.each do |field|
        if KNOWN_FIELDS.include? field
          if apage.data.key? field
            result += "#{apage.data[field]} "
          else
            @logger.warn { "#{field} is a known field, but it was not present in apage #{apage}" }
          end
        else
          result += "#{field} "
        end
      end
      result
    end

    def render_outline_apage
      <<~END_ENTRY
        <span>#{@date.strftime('%Y-%m-%d')}</span>
              <span><a href='#{@url}'>#{@title}</a>#{@draft}</span>
      END_ENTRY
    end
  end
end
