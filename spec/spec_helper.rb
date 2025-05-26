require 'jekyll'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
# require_relative '../lib/jekyll_outline'

module JekyllSupport
  # TODO: more to $jekyll_plugin_support/lib/jekyll_plugin_support/jekyll_plugin_support_class.rb
  def self.apage_from(
    date: nil,
    last_modified: nil,
    order: nil,
    title: nil,
    url: nil,
    draft: false,
    label: nil
  )
    obj = {
      data: {
        collection:    { label: label },
        date:          Date.parse(date),
        draft:         draft,
        last_modified: Date.parse(last_modified || date),
        order:         order,
        title:         title,
      },
      url:  url,
    }

    obj.new_attribute :extname, '.html'
    # obj.class.module_eval { attr_accessor :extname }
    # obj.extname = '.html'

    obj.new_attribute :logger, PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
    # obj.class.module_eval { attr_accessor :logger }
    # obj.logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

    obj.new_attribute :url, url
    # obj.class.module_eval { attr_accessor :url }
    # obj.url = url

    ::AllCollectionsHooks::APage.new obj, nil
  end

  # TODO: more to $jekyll_plugin_support/lib/jekyll_plugin_support/jekyll_plugin_support_class.rb
  # Defines a new attribute called `prop_name` in object `obj` and sets it to `prop_value`
  def self.new_attribute(obj, prop_name, prop_value)
    obj.class.module_eval { attr_accessor prop_name }
    obj.instance_variable_set ":@#{prop_name}", prop_value
  end
end

RSpec.configure do |config|
  config.filter_run_when_matching focus: true
  config.order = 'random'

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = 'spec/status_persistence.txt'
end
