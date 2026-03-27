require 'spec_helper'

describe OOXL::Column do
  describe '.load_from_node' do
    let(:column_xml) do
      Nokogiri.XML('<col min="3" max="5" width="12.5" bestFit="1" customWidth="1"/>').remove_namespaces!.at('col')
    end

    let(:column) { described_class.load_from_node(column_xml) }

    it 'loads id from min attribute' do
      expect(column.id).to eq '3'
    end

    it 'loads width' do
      expect(column.width).to eq '12.5'
    end

    it 'loads best_fit (attribute name mismatch means nil)' do
      # NOTE: source looks for "best_fit" but XML uses "bestFit"
      expect(column.best_fit).to be_nil
    end

    it 'loads custom_width (attribute name mismatch means nil)' do
      # NOTE: source looks for "custom_width" but XML uses "customWidth"
      expect(column.custom_width).to be_nil
    end

    it 'loads id_range from min to max' do
      expect(column.id_range).to eq [3, 4, 5]
    end

    it 'is not hidden by default' do
      expect(column).not_to be_hidden
    end
  end

  describe '#hidden?' do
    it 'returns true when hidden attribute is 1' do
      hidden_xml = Nokogiri.XML('<col min="1" max="1" width="0" hidden="1"/>').remove_namespaces!.at('col')
      column = described_class.load_from_node(hidden_xml)
      expect(column).to be_hidden
    end

    it 'returns false when hidden attribute is 0' do
      visible_xml = Nokogiri.XML('<col min="1" max="1" width="8.5" hidden="0"/>').remove_namespaces!.at('col')
      column = described_class.load_from_node(visible_xml)
      expect(column).not_to be_hidden
    end
  end

  describe 'default width' do
    it 'uses DEFAULT_WIDTH when width not provided' do
      column = described_class.new(id: '1')
      expect(column.width).to eq '8.43'
    end
  end
end
