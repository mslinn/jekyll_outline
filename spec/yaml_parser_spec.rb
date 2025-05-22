require 'rspec/match_ignoring_whitespace'
require_relative '../lib/yaml_parser'

RSpec.describe(YamlParser) do
  expected = ''
  actual = ''

  it 'parses yaml' do
    expect(expected).to match_ignoring_whitespace(actual)
  end
end
