require 'spec_helper'

describe OOXL::NumberFormatting do
  describe '.load_from_node' do
    it 'loads id and code from node' do
      xml = Nokogiri.XML('<numFmt numFmtId="164" formatCode="0.00"/>').remove_namespaces!.at('numFmt')
      nf = described_class.load_from_node(xml)

      expect(nf.id).to eq '164'
      expect(nf.code).to eq '0.00'
    end

    it 'handles date format codes' do
      xml = Nokogiri.XML('<numFmt numFmtId="179" formatCode="mm/dd/yy"/>').remove_namespaces!.at('numFmt')
      nf = described_class.load_from_node(xml)

      expect(nf.id).to eq '179'
      expect(nf.code).to eq 'mm/dd/yy'
    end

    it 'handles complex format codes' do
      xml = Nokogiri.XML('<numFmt numFmtId="187" formatCode="[$-F800]dddd\\,\\ mmmm\\ dd\\,\\ yyyy"/>').remove_namespaces!.at('numFmt')
      nf = described_class.load_from_node(xml)

      expect(nf.id).to eq '187'
      expect(nf.code).to include 'dddd'
    end
  end
end
