require 'spec_helper'

describe OOXL::Util do
  let(:util) { Class.new { extend OOXL::Util } }

  describe '#column_letter_to_number' do
    it 'converts single letters' do
      expect(util.column_letter_to_number('A')).to eq 1
      expect(util.column_letter_to_number('Z')).to eq 26
    end

    it 'converts double letters' do
      expect(util.column_letter_to_number('AA')).to eq 27
      expect(util.column_letter_to_number('AZ')).to eq 52
      expect(util.column_letter_to_number('BA')).to eq 53
    end
  end

  describe '#column_number_to_letter' do
    it 'converts numbers to letters' do
      expect(util.column_number_to_letter(1)).to eq 'A'
      expect(util.column_number_to_letter(26)).to eq 'Z'
      expect(util.column_number_to_letter(27)).to eq 'AA'
    end
  end

  describe '#letter_index' do
    it 'returns zero-based index for column letter' do
      expect(util.letter_index('A')).to eq 0
      expect(util.letter_index('B')).to eq 1
      expect(util.letter_index('Z')).to eq 25
    end
  end

  describe '#letter_equivalent' do
    it 'returns column letter for zero-based index' do
      expect(util.letter_equivalent(0)).to eq 'A'
      expect(util.letter_equivalent(1)).to eq 'B'
      expect(util.letter_equivalent(25)).to eq 'Z'
    end
  end

  describe '#to_column_letter' do
    it 'strips digits from reference' do
      expect(util.to_column_letter('A1')).to eq 'A'
      expect(util.to_column_letter('AB123')).to eq 'AB'
    end
  end

  describe '#uniform_reference' do
    it 'returns number for letter reference' do
      expect(util.uniform_reference('A')).to eq 1
      expect(util.uniform_reference('B')).to eq 2
    end

    it 'returns numeric reference as-is' do
      expect(util.uniform_reference(3)).to eq 3
    end
  end

  describe '#node_attribute_value' do
    it 'extracts attribute value from node' do
      node = Nokogiri.XML('<c r="A1" t="s"/>').remove_namespaces!.at('c')
      expect(util.node_attribute_value(node, 'r')).to eq 'A1'
      expect(util.node_attribute_value(node, 't')).to eq 's'
    end

    it 'returns nil for missing attribute' do
      node = Nokogiri.XML('<c r="A1"/>').remove_namespaces!.at('c')
      expect(util.node_attribute_value(node, 'z')).to be_nil
    end

    it 'returns nil for blank node' do
      expect(util.node_attribute_value(nil, 'r')).to be_nil
    end
  end
end
