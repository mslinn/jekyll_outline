require 'rspec/match_ignoring_whitespace'
require_relative '../lib/yaml_parser'

RSpec.describe(JekyllSupport::YamlParser) do
  yaml_parser = described_class.new <<~END_DATA
    0: Production Infrastructure
    15000: Audio
    20000: Video
    30000: RME
    40000: OBS Studio
    50000: Pro Tools
    55000: Ableton Live &amp; Push
    60000: Other Music Software
    70000: MIDI Hardware &amp; Software
    80000: Davinci Resolve
    100000: Computer Analysis
    200000: Music Theory
    300000: Business
    400000: General
  END_DATA

  it 'found the section headings' do
    expect(yaml_parser.headers.count).to equal(14)
  end

  # it 'The first section heading looks ok' do
  #   first_heading = yaml_parser.headers.first
  #   # expect(first_heading.).to equal(14)
  # end

  it 'parses yaml' do
    expected = ''
    actual = ''
    expect(expected).to match_ignoring_whitespace(actual)
  end
end
