require 'spec_helper'

describe OOXL::Sheet::DataValidation do
  describe '.load_from_node' do
    it 'loads all attributes from standard node' do
      xml = Nokogiri.XML(
        '<dataValidation type="list" allowBlank="1" prompt="Select one" sqref="A1">
          <formula1>named_range</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)

      expect(dv.type).to eq 'list'
      expect(dv.allow_blank).to eq '1'
      expect(dv.prompt).to eq 'Select one'
      expect(dv.sqref).to eq 'A1'
      expect(dv.formula).to eq 'named_range'
    end

    it 'loads sqref from child element when attribute missing' do
      xml = Nokogiri.XML(
        '<dataValidation type="list">
          <sqref>B2:B100</sqref>
          <formula1>choices</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)
      expect(dv.sqref).to eq 'B2:B100'
    end
  end

  describe '#in_sqref_range?' do
    it 'matches single cell sqref' do
      xml = Nokogiri.XML(
        '<dataValidation type="list" sqref="B6">
          <formula1>test</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)

      expect(dv.in_sqref_range?('B6')).to be true
      expect(dv).not_to be_in_sqref_range('B7')
      expect(dv).not_to be_in_sqref_range('C6')
    end

    it 'matches range sqref' do
      xml = Nokogiri.XML(
        '<dataValidation type="list" sqref="A1:A10">
          <formula1>test</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)

      expect(dv.in_sqref_range?('A1')).to be true
      expect(dv.in_sqref_range?('A10')).to be true
      expect(dv.in_sqref_range?('A5')).to be true
      expect(dv).not_to be_in_sqref_range('B5')
    end

    it 'matches multiple space-separated sqrefs' do
      xml = Nokogiri.XML(
        '<dataValidation type="list" sqref="A1:A5 B1:B5">
          <formula1>test</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)

      expect(dv.in_sqref_range?('A3')).to be true
      expect(dv.in_sqref_range?('B3')).to be true
      expect(dv).not_to be_in_sqref_range('C3')
    end

    it 'returns false for blank cell_id' do
      xml = Nokogiri.XML(
        '<dataValidation type="list" sqref="A1">
          <formula1>test</formula1>
        </dataValidation>',
      ).remove_namespaces!.at('dataValidation')

      dv = described_class.load_from_node(xml)
      expect(dv.in_sqref_range?('')).to be false
    end
  end
end
