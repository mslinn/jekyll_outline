require 'spec_helper'
require 'rspec/match_ignoring_whitespace'
require_relative '../lib/structure/outline'
require_relative '../lib/structure/yaml_parser'

module JekyllSupport
  logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)
  outline_options = OutlineOptions.new

  # includes leading zeros and leading spaces, which are invalid in YAML
  yaml_parser_big = YamlParser.new outline_options, <<~END_DATA
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

  RSpec.describe(YamlParser) do
    it 'handles no section headings' do
      yaml_parser = described_class.new outline_options
      sections = yaml_parser.sections
      expect(sections.count).to equal(0)

      yaml_parser = described_class.new outline_options, ''
      sections = yaml_parser.sections
      expect(sections.count).to equal(0)
    end

    it 'finds only 1 section heading' do
      yaml_parser = described_class.new outline_options, '0: General'
      sections = yaml_parser.sections
      expect(sections.count).to equal(1)
      # expect(sections.first)

      yaml_parser = described_class.new outline_options, <<~END_DATA
        0: General
      END_DATA
      sections = yaml_parser.sections
      expect(sections.count).to equal(1)

      # Handle leading space (this is invalid YAML) and the lack of an end of line character
      yaml_parser = described_class.new outline_options, ' 0: General'
      sections = yaml_parser.sections
      expect(sections.count).to equal(1)
    end

    it 'finds matching sections' do
      sections = yaml_parser_big.sections
      expect(sections.count).to equal(14)

      section1 = sections.first
      expect(section1.order).to eq(0)
      expect(section1.title).to eq('Production Infrastructure')

      outline = Outline.new.add_sections sections

      apage0 = JekyllSupport.apage_from(date: Time.now, logger: logger, order: 0)
      actual_section = outline.send :section_for, apage0
      expect(actual_section.order).to eq(0)

      apage1000 = JekyllSupport.apage_from(date: Time.now, logger: logger, order: 1000)
      actual_section = outline.send :section_for, apage1000
      expect(actual_section.order).to eq(0)

      apage16000 = JekyllSupport.apage_from(date: Time.now, logger: logger, order: 16_000)
      actual_section = outline.send :section_for, apage16000
      expect(actual_section.order).to eq(15_000)

      apage25000 = JekyllSupport.apage_from(date: Time.now, logger: logger, order: 25_000)
      actual_section = outline.send :section_for, apage25000
      expect(actual_section.order).to eq(20_000)
    end
  end
end
