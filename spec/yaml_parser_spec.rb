require 'rspec/match_ignoring_whitespace'
require_relative '../lib/yaml_parser'

RSpec.describe(JekyllSupport::YamlParser) do
  it 'handles no section headings' do
    yaml_parser = described_class.new
    sections = yaml_parser.sections
    expect(sections.count).to equal(0)

    yaml_parser = described_class.new ''
    sections = yaml_parser.sections
    expect(sections.count).to equal(0)
  end

  it 'finds only 1 section heading' do
    yaml_parser = described_class.new '0: General'
    sections = yaml_parser.sections
    expect(sections.count).to equal(1)
    # expect(sections.first)

    yaml_parser = described_class.new <<~END_DATA
      0: General
    END_DATA
    sections = yaml_parser.sections
    expect(sections.count).to equal(1)

    # Handle leading space (this is invalid YAML) and the lack of an end of line character
    yaml_parser = described_class.new ' 0: General'
    sections = yaml_parser.sections
    expect(sections.count).to equal(1)
  end

  it 'finds section headings' do
    # includes leading zeros and leading spaces, which are invalid in YAML
    yaml_parser = described_class.new <<~END_DATA
        0: Production Infrastructure
      0015000: Audio
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

    sections = yaml_parser.sections
    expect(sections.count).to equal(14)

    section1 = sections.first
    expect(section1.order).to eq(0)
    expect(section1.title).to eq('Production Infrastructure')
  end
end
