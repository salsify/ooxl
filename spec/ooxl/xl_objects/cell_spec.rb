require 'spec_helper'

describe OOXL::Cell do
  let(:shared_strings) { %w[Hello World Test] }
  let(:styles) { double('styles') }

  let(:cell_xml) do
    Nokogiri.XML('<c r="B3" s="1" t="s"><v>0</v></c>').remove_namespaces!.at('c')
  end

  let(:cell) { described_class.load_from_node(cell_xml, shared_strings, styles) }

  describe '.load_from_node' do
    it 'loads cell id' do
      expect(cell.id).to eq 'B3'
    end

    it 'loads cell type_id' do
      expect(cell.type_id).to eq 's'
    end

    it 'loads cell style_id' do
      expect(cell.style_id).to eq '1'
    end

    it 'resolves shared string value' do
      expect(cell.value).to eq 'Hello'
    end
  end

  describe '#column' do
    it 'extracts column letter from id' do
      expect(cell.column).to eq 'B'
    end

    it 'handles multi-letter columns' do
      multi_col_cell = described_class.new(id: 'AA12')
      expect(multi_col_cell.column).to eq 'AA'
    end
  end

  describe '#row' do
    it 'extracts row number from id' do
      expect(cell.row).to eq '3'
    end

    it 'handles multi-digit rows' do
      multi_row_cell = described_class.new(id: 'A100')
      expect(multi_row_cell.row).to eq '100'
    end
  end

  describe '#type' do
    it 'returns :string for type s' do
      expect(cell.type).to eq :string
    end

    it 'returns :number for type n' do
      num_cell = described_class.new(id: 'A1', type_id: 'n')
      expect(num_cell.type).to eq :number
    end

    it 'returns :boolean for type b' do
      bool_cell = described_class.new(id: 'A1', type_id: 'b')
      expect(bool_cell.type).to eq :boolean
    end

    it 'returns :date for type d' do
      date_cell = described_class.new(id: 'A1', type_id: 'd')
      expect(date_cell.type).to eq :date
    end

    it 'returns :formula for type str' do
      formula_cell = described_class.new(id: 'A1', type_id: 'str')
      expect(formula_cell.type).to eq :formula
    end

    it 'returns :inline_str for type inlineStr' do
      inline_cell = described_class.new(id: 'A1', type_id: 'inlineStr')
      expect(inline_cell.type).to eq :inline_str
    end

    it 'returns :error for unknown type' do
      error_cell = described_class.new(id: 'A1', type_id: 'x')
      expect(error_cell.type).to eq :error
    end
  end

  describe '#next_id' do
    let(:simple_cell) { described_class.new(id: 'B3') }

    it 'returns bottom neighbor by default' do
      expect(simple_cell.next_id).to eq 'B4'
    end

    it 'returns top neighbor' do
      expect(simple_cell.next_id(location: 'top')).to eq 'B2'
    end

    it 'clamps top to row 1' do
      top_cell = described_class.new(id: 'B1')
      expect(top_cell.next_id(location: 'top')).to eq 'B1'
    end

    it 'returns right neighbor' do
      expect(simple_cell.next_id(location: 'right')).to eq 'C3'
    end

    it 'returns left neighbor' do
      expect(simple_cell.next_id(location: 'left')).to eq 'A3'
    end

    it 'clamps left at column A' do
      left_cell = described_class.new(id: 'A3')
      expect(left_cell.next_id(location: 'left')).to eq 'A3'
    end

    it 'supports custom offset for bottom' do
      expect(simple_cell.next_id(offset: 3, location: 'bottom')).to eq 'B6'
    end

    it 'supports custom offset for right' do
      expect(simple_cell.next_id(offset: 2, location: 'right')).to eq 'D3'
    end
  end

  describe '#formula' do
    it 'loads formula from node' do
      formula_xml = Nokogiri.XML('<c r="A1" t="s"><f>SUM(A1:A10)</f></c>').remove_namespaces!.at('c')
      formula_cell = described_class.load_from_node(formula_xml, shared_strings, styles)
      expect(formula_cell.formula).to eq 'SUM(A1:A10)'
    end

    it 'returns nil when no formula' do
      expect(cell.formula).to be_nil
    end
  end

  describe '#style' do
    it 'returns style when style_id present' do
      style_result = { font: double, fill: double, number_format: '0.00' }
      allow(styles).to receive(:by_id).with(1).and_return(style_result)
      expect(cell.style).to eq style_result
    end
  end

  describe '#number_format' do
    it 'returns number format from style' do
      style_result = { font: double, fill: double, number_format: '0.00\\%' }
      allow(styles).to receive(:by_id).with(1).and_return(style_result)
      expect(cell.number_format).to eq '0.00%'
    end

    it 'returns nil when no style' do
      no_style_cell = described_class.new(id: 'A1', style_id: nil, styles: styles)
      expect(no_style_cell.number_format).to be_nil
    end
  end

  describe '#font' do
    it 'returns font from style' do
      font_obj = double('font')
      style_result = { font: font_obj, fill: double, number_format: nil }
      allow(styles).to receive(:by_id).with(1).and_return(style_result)
      expect(cell.font).to eq font_obj
    end
  end

  describe '#fill' do
    it 'returns fill from style' do
      fill_obj = double('fill')
      style_result = { font: double, fill: fill_obj, number_format: nil }
      allow(styles).to receive(:by_id).with(1).and_return(style_result)
      expect(cell.fill).to eq fill_obj
    end
  end

  describe '.extract_value' do
    it 'resolves shared string by index' do
      node = Nokogiri.XML('<c t="s"><v>1</v></c>').remove_namespaces!.at('c')
      expect(described_class.extract_value('s', node, shared_strings)).to eq 'World'
    end

    it 'returns nil for empty shared string ref' do
      node = Nokogiri.XML('<c t="s"></c>').remove_namespaces!.at('c')
      expect(described_class.extract_value('s', node, shared_strings)).to be_nil
    end

    it 'extracts inline string value' do
      node = Nokogiri.XML('<c t="inlineStr"><is><t>Inline</t></is></c>').remove_namespaces!.at('c')
      expect(described_class.extract_value('inlineStr', node, shared_strings)).to eq 'Inline'
    end

    it 'extracts inline string with rich text' do
      node = Nokogiri.XML('<c t="inlineStr"><is><r><t>Rich</t></r><r><t> Text</t></r></is></c>').remove_namespaces!.at('c')
      expect(described_class.extract_value('inlineStr', node, shared_strings)).to eq 'Rich Text'
    end

    it 'returns raw value for numeric types' do
      node = Nokogiri.XML('<c t="n"><v>42</v></c>').remove_namespaces!.at('c')
      expect(described_class.extract_value('n', node, shared_strings)).to eq '42'
    end
  end

  describe OOXL::BlankCell do
    let(:blank_cell) { described_class.new('C5') }

    it 'stores the id' do
      expect(blank_cell.id).to eq 'C5'
    end

    it 'returns nil for value' do
      expect(blank_cell.value).to be_nil
    end

    it 'extracts column letter' do
      expect(blank_cell.column).to eq 'C'
    end

    it 'extracts row number' do
      expect(blank_cell.row).to eq '5'
    end
  end
end
