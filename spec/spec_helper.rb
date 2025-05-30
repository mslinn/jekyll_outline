require 'jekyll'
require 'jekyll_plugin_logger'
require 'jekyll_plugin_support'

RSpec.configure do |config|
  # See https://www.rubydoc.info/github/rspec/rspec-core/RSpec%2FCore%2FConfiguration:pending_failure_output
  config.pending_failure_output = :skip
  config.filter_run_when_matching focus: true
  config.order = 'random'

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = 'spec/status_persistence.txt'
end
