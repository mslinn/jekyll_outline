require 'yaml'
require_relative 'section'

class OutlineError < StandardError; end

module JekyllSupport
  class YamlParser
    attr_reader :sections

    # @return array of empty Sections
    def initialize(outline_options, content = '')
      @logger = outline_options.logger
      @sections = if content && !content.strip.empty?
                    parse_sections outline_options, content
                  else
                    []
                  end
    end

    # @return Array of Sections that do not contain children
    def parse_sections(outline_options, content)
      content = remove_leading_zeros remove_leading_spaces content
      yaml = YAML.safe_load content
      yaml.map { |entry| Section.new outline_options, entry }
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

    private

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
