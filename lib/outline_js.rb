require 'jekyll_plugin_support'
require_relative 'jekyll_outline/version'

module OutlineJsTag
  PLUGIN_JS_NAME = 'outline_js'.freeze

  class OutlineJsTag < JekyllSupport::JekyllTag
    include JekyllOutlineVersion

    def render_impl
      wrap_in_script_tag = @helper.parameter_specified?('wrap_in_script_tag')

      gem_path = Gem::Specification.find_by_name('jekyll_outline').full_gem_path
      js_path = File.join(gem_path, 'demo/assets/js/jekyll_outline.js')
      js = File.read(js_path)

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
