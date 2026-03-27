require 'spec_helper'

describe OOXL::CellStyleReference do
  describe '.load_from_node' do
    it 'loads all attributes from node' do
      xml = Nokogiri.XML('<xf numFmtId="164" fontId="2" fillId="3" xfId="0"/>').remove_namespaces!.at('xf')
      ref = described_class.load_from_node(xml)

      expect(ref.number_formatting_id).to eq 164
      expect(ref.font_id).to eq 2
      expect(ref.fill_id).to eq 3
      expect(ref.id).to eq 0
    end

    it 'handles missing xfId' do
      xml = Nokogiri.XML('<xf numFmtId="0" fontId="0" fillId="0"/>').remove_namespaces!.at('xf')
      ref = described_class.load_from_node(xml)

      expect(ref.id).to be_nil
      expect(ref.number_formatting_id).to eq 0
      expect(ref.font_id).to eq 0
      expect(ref.fill_id).to eq 0
    end
  end
end
