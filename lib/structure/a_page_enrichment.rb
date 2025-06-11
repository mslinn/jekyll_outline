# Enriches JekyllSupport.APage
module JekyllSupport
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  # Overrides definition from `jekyll_plugin_support`
  class APage
    def render_outline_apage(pattern)
      <<~END_ENTRY
        <span>#{@last_modified.strftime('%Y-%m-%d')}</span>
              <span><a href='#{@url}'>#{render_entry_details pattern}</a>#{@draft}</span>
      END_ENTRY
    end

    # @param pattern can either be a String or [String]
    # Renders a section entry as a string
    # Recognized tokens are looked up, otherwise they are incorporated into the output
    # Currently spaces are the only valid delimiters; HTML tags should be tokenized even when not delimited by spaces
    def render_entry_details(pattern)
      result = ''
      fields = case pattern
               when String
                 pattern.split
               when Array
                 pattern
               else
                 @logger.error { "Pattern is neither a String nor an Array (#{pattern})" }
               end
      fields.each do |field|
        if KNOWN_FIELDS.include? field
          if respond_to? field
            value = send field
            result += "#{value} "
          elsif data.key?(field.to_sym) || data.key?(field.to_s)
            value = data[field.to_sym] || data[field.to_s]
            result += "#{value} "
          else
            @logger.warn { "'#{field}' is a known field, but it was not present in apage with url '#{@url}'." }
          end
        else
          result += "#{field} "
        end
      end
      result
    end
  end
end
