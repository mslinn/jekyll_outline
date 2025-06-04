# Enriches AllCollectionsHooks.APage
module AllCollectionsHooks
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

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

    def render_outline_apage(pattern)
      <<~END_ENTRY
        <span>#{@last_modified.strftime('%Y-%m-%d')}</span>
              <span><a href='#{@url}'>#{render_entry_details pattern}</a>#{@draft}</span>
      END_ENTRY
    end

    # Renders a section entry as a string
    # Recognized tokens are looked up, otherwise they are incorporated into the output
    # Currently spaces are the only valid delimiters; HTML tags should be tokenized even when not delimited by spaces
    def render_entry_details(pattern)
      result = ''
      pattern.split.each do |field|
        if KNOWN_FIELDS.include? field
          if data.key?(field.to_sym) || data.key?(field.to_s)
            value = data[field.to_sym] || data[field.to_s]
            result += "#{value} "
          else
            @logger.warn { "#{field} is a known field, but it was not present in apage #{@url}" }
          end
        else
          result += "#{field} "
        end
      end
      result
    end
  end
end
