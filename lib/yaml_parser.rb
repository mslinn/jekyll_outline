require 'yaml'

class YamlParser
  FIXNUM_MAX = (2**((0.size * 8) - 2)) - 1
  KNOWN_FIELDS = %w[draft categories description date last_modified_at layout order title slug ext tags excerpt].freeze

  attr_accessor :headers

  def initialize(content)
    @headers = parse_headers content
  end

  def handle(entry)
    visible_line = handle_entry entry
    result = "    <span>#{date}</span> <span><a href='#{entry.url}'>#{visible_line.strip}</a>#{draft}</span>"
    result = section_start + result if section_start
    result
  end

  def handle_entry(entry)
    result = ''
    @fields.each do |field|
      if KNOWN_FIELDS.include? field
        if entry.data.key? field
          result += "#{entry.data[field]} "
        else
          @logger.warn { "#{field} is a known field, but it was not present in entry #{entry}" }
        end
      else
        result += "#{field} "
      end
    end
    result
  end

  # Sort entries within the outline tag which do not have the property specified by @sort_by at the end
  def obtain_field
    sort_by = @sort_by.to_s
    proc do |entry|
      if entry.respond_to? :data # page
        entry.data.key?(sort_by) ? entry.data[sort_by] || 'zzz' : 'zzz'
      else # heading
        entry.respond_to?(sort_by) ? entry.send(sort_by) || 'zzz' : 'zzz'
      end
    end
  end

  # Sort entries within the outline tag which do not have an order property at the end
  def obtain_order
    proc do |entry|
      if entry.respond_to? :data # page
        entry.data.key?('order') ? entry.data['order'] || FIXNUM_MAX : FIXNUM_MAX
      else # heading
        entry.order || FIXNUM_MAX
      end
    end
  end

  def parse_headers(content)
    content = remove_leading_zeros remove_leading_spaces content
    yaml = YAML.safe_load content
    yaml.map { |entry| Header.new entry }
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

  def remove_empty_headers(array)
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
