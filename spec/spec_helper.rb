require 'jekyll'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'
# require_relative '../lib/jekyll_outline'

RSpec.configure do |config|
  config.filter_run_excluding block: nil # See https://github.com/rspec/rspec-core/issues/2377#issuecomment-275411915
  config.filter_run_when_matching focus: true
  config.order = 'random'

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = 'spec/status_persistence.txt'
end
