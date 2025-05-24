require 'yaml'
require_relative 'structure'

module JekyllSupport
  class YamlParser
    FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1
    KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

    attr_accessor :sections

    # @return array of empty Sections
    def initialize(content = '')
      @sections = if content && !content.strip.empty?
                    parse_sections content
                  else
                    []
                  end
    end

    def parse_sections(content)
      content = remove_leading_zeros remove_leading_spaces content
      yaml = YAML.safe_load content
      yaml.map { |entry| Section.new entry }
    rescue NoMethodError => e
      raise OutlineError, <<~END_MSG
        Invalid YAML within {% outline %} tag. The offending content was:

        <pre>#{content}</pre>
      END_MSG
    rescue Psych::SyntaxError => e
      msg = <<~END_MSG
        Invalid YAML found within {% outline %} tag:<br>
        <pre>#{e.message}</pre>
      END_MSG
      @logger.error { e.message }
      raise OutlineError, msg
    end

    def remove_empty_sections(array)
      i = 0
      while i < array.length - 1
        if header?(array[i]) && header?(array[i + 1])
          array.delete_at(i)
        else
          i += 1
        end
      end

      array.delete_at(array.length - 1) if header?(array.last)
      array
    end

    def remove_leading_spaces(multiline)
      multiline
        .strip
        .split("\n")
        .map { |x| x.gsub(/\A\s+/, '') }
        .join("\n")
    end

    def remove_leading_zeros(multiline)
      multiline
        .strip
        .split("\n")
        .map { |x| x.gsub(/(?<= |\A)0+(?=\d)/, '') }
        .join("\n")
    end
  end
end
