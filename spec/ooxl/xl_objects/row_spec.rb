require 'spec_helper'

describe OOXL::Row do
  let(:shared_strings) { %w[Hello World Test] }
  let(:styles) { double('styles') }

  let(:row_xml) do
    Nokogiri.XML(
      '<row r="3" spans="1:3" ht="20.5">
        <c r="A3" t="s"><v>0</v></c>
        <c r="B3" t="s"><v>1</v></c>
        <c r="C3" t="s"><v>2</v></c>
      </row>',
    ).remove_namespaces!.at('row')
  end

  let(:row) { described_class.load_from_node(row_xml, shared_strings, styles, {}) }

  describe '.load_from_node' do
    it 'loads row id' do
      expect(row.id).to eq '3'
    end

    it 'loads row spans' do
      expect(row.spans).to eq '1:3'
    end

    it 'loads row height' do
      expect(row.height).to eq '20.5'
    end

    it 'loads cells' do
      expect(row.cells.size).to eq 3
      expect(row.cells.first.value).to eq 'Hello'
    end
  end

  describe '.extract_id' do
    it 'extracts row id from node' do
      expect(described_class.extract_id(row_xml)).to eq '3'
    end
  end

  describe '#[]' do
    it 'accesses cell by string id' do
      expect(row['A3'].value).to eq 'Hello'
    end

    it 'accesses cell by integer index' do
      expect(row[0].value).to eq 'Hello'
      expect(row[1].value).to eq 'World'
    end

    it 'returns BlankCell for non-existent integer index' do
      expect(row[99]).to be_a OOXL::BlankCell
    end
  end

  describe '#cell' do
    it 'finds cell by full id' do
      expect(row.cell('B3').value).to eq 'World'
    end

    it 'finds cell by column letter, appending row id' do
      expect(row.cell('C').value).to eq 'Test'
    end

    it 'returns BlankCell for non-existent cell' do
      expect(row.cell('Z3')).to be_a OOXL::BlankCell
    end
  end

  describe '#each' do
    it 'iterates over cells' do
      values = row.map(&:value)
      expect(values).to eq %w[Hello World Test]
    end
  end

  describe 'default height' do
    it 'uses DEFAULT_HEIGHT when height not provided' do
      no_height_xml = Nokogiri.XML(
        '<row r="1" spans="1:1"><c r="A1" t="s"><v>0</v></c></row>',
      ).remove_namespaces!.at('row')

      no_height_row = described_class.load_from_node(no_height_xml, shared_strings, styles, {})
      expect(no_height_row.height).to eq '12.75'
    end
  end

  describe 'padded_cells option' do
    it 'stores the padded_cells option' do
      padded_row = described_class.new(id: '1', cells: [], options: { padded_cells: true })
      # padded_cells returns nil for empty cells
      expect(padded_row.cells).to be_nil
    end
  end
end
