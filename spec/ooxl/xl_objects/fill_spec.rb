require 'spec_helper'

describe OOXL::Fill do
  describe '.load_from_node' do
    it 'loads solid fill with all color attributes' do
      xml = Nokogiri.XML(
        '<fill>
          <patternFill patternType="solid">
            <fgColor rgb="FFFF0000" theme="3" tint="-0.25" indexed="5"/>
            <bgColor rgb="FF00FF00" index="64"/>
          </patternFill>
        </fill>',
      ).remove_namespaces!.at('fill')

      fill = described_class.load_from_node(xml)

      expect(fill.pattern_type).to eq 'solid'
      expect(fill.fg_color).to eq 'FFFF0000'
      expect(fill.fg_color_theme).to eq '3'
      expect(fill.fg_color_tint).to eq '-0.25'
      expect(fill.fg_color_index).to eq '5'
      expect(fill.bg_color).to eq 'FF00FF00'
      expect(fill.bg_color_index).to eq '64'
    end

    it 'loads non-solid pattern fill' do
      xml = Nokogiri.XML(
        '<fill>
          <patternFill patternType="gray125"/>
        </fill>',
      ).remove_namespaces!.at('fill')

      fill = described_class.load_from_node(xml)

      expect(fill.pattern_type).to eq 'gray125'
      expect(fill.fg_color).to be_nil
      expect(fill.bg_color).to be_nil
    end

    it 'loads none pattern fill' do
      xml = Nokogiri.XML(
        '<fill>
          <patternFill patternType="none"/>
        </fill>',
      ).remove_namespaces!.at('fill')

      fill = described_class.load_from_node(xml)

      expect(fill.pattern_type).to eq 'none'
    end
  end
end
