require 'rspec/match_ignoring_whitespace'
require_relative '../lib/structure'

RSpec.describe(Structure) do
  expected = ''
  actual = ''

  it 'parses content' do
    expect(expected).to match_ignoring_whitespace(actual)
  end
end
