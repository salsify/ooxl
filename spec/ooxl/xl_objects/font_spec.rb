require 'spec_helper'

describe OOXL::Font do
  describe '.load_from_node' do
    it 'loads all font attributes' do
      xml = Nokogiri.XML(
        '<font>
          <sz val="12"/>
          <name val="Calibri"/>
          <color rgb="FF000000" theme="1" indexed="8"/>
          <b/>
        </font>',
      ).remove_namespaces!.at('font')

      font = described_class.load_from_node(xml)

      expect(font.size).to eq '12'
      expect(font.name).to eq 'Calibri'
      expect(font.rgb_color).to eq 'FF000000'
      expect(font.theme).to eq '1'
      expect(font.color_index).to eq '8'
      expect(font).to be_bold
    end

    it 'handles non-bold font' do
      xml = Nokogiri.XML(
        '<font>
          <sz val="10"/>
          <name val="Arial"/>
        </font>',
      ).remove_namespaces!.at('font')

      font = described_class.load_from_node(xml)

      expect(font).not_to be_bold
      expect(font.rgb_color).to be_nil
      expect(font.theme).to be_nil
      expect(font.color_index).to be_nil
    end

    it 'handles font without size or name' do
      xml = Nokogiri.XML('<font/>').remove_namespaces!.at('font')
      font = described_class.load_from_node(xml)

      expect(font.size).to be_nil
      expect(font.name).to be_nil
    end
  end
end
