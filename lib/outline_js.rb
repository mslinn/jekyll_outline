require 'jekyll_plugin_support'
require_relative 'jekyll_outline/version'

module OutlineJsTag
  PLUGIN_JS_NAME = 'outline_js'.freeze

  class OutlineJsTag < JekyllSupport::JekyllTag
    include JekyllOutlineVersion

    def render_impl
      wrap_in_script_tag = @helper.parameter_specified?('wrap_in_script_tag')
      js = File.read('assets/js/jekyll_outline.js')
      if wrap_in_script_tag
        <<~END_JS
          <script>
            #{indent(js)}
          </script>
        END_JS
      else
        js
      end
    end

    private

    def indent(multiline)
      multiline
        .strip
        .split("\n")
        .map { |x| "  #{x}" }
        .join("\n")
    end

    JekyllPluginHelper.register(self, PLUGIN_JS_NAME)
  end
end
