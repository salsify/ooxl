require 'spec_helper'

describe OOXL::Styles do
  let(:styles_xml) do
    <<~XML
      <styleSheet>
        <numFmts count="2">
          <numFmt numFmtId="164" formatCode="0.00"/>
          <numFmt numFmtId="165" formatCode="mm/dd/yyyy"/>
        </numFmts>
        <fonts count="2">
          <font>
            <sz val="10"/>
            <name val="Arial"/>
          </font>
          <font>
            <b/>
            <sz val="12"/>
            <name val="Calibri"/>
            <color rgb="FF0000FF"/>
          </font>
        </fonts>
        <fills count="2">
          <fill>
            <patternFill patternType="none"/>
          </fill>
          <fill>
            <patternFill patternType="solid">
              <fgColor rgb="FFFFFF00"/>
              <bgColor indexed="64"/>
            </patternFill>
          </fill>
        </fills>
        <cellXfs count="2">
          <xf numFmtId="164" fontId="0" fillId="0"/>
          <xf numFmtId="165" fontId="1" fillId="1"/>
        </cellXfs>
      </styleSheet>
    XML
  end

  let(:styles) { described_class.load_from_stream(styles_xml) }

  describe '.load_from_stream' do
    it 'loads fonts' do
      expect(styles.fonts.size).to eq 2
      expect(styles.fonts.first).to be_a OOXL::Font
      expect(styles.fonts.first.name).to eq 'Arial'
    end

    it 'loads fills' do
      expect(styles.fills.size).to eq 2
    end

    it 'loads number formats' do
      expect(styles.number_formats.size).to eq 2
      expect(styles.number_formats.first.code).to eq '0.00'
    end

    it 'loads cell style references' do
      expect(styles.cell_style_xfs.size).to eq 2
    end
  end

  describe '#by_id' do
    it 'returns font, fill, and number_format for a style id' do
      result = styles.by_id(0)
      expect(result[:font]).to be_a OOXL::Font
      expect(result[:font].name).to eq 'Arial'
      expect(result[:number_format]).to eq '0.00'
    end

    it 'returns correct style for second id' do
      result = styles.by_id(1)
      expect(result[:font].name).to eq 'Calibri'
      expect(result[:number_format]).to eq 'mm/dd/yyyy'
    end
  end

  describe '#fonts_by_index' do
    it 'returns font at given index' do
      expect(styles.fonts_by_index(0).name).to eq 'Arial'
      expect(styles.fonts_by_index(1).name).to eq 'Calibri'
    end

    it 'returns nil for blank index' do
      expect(styles.fonts_by_index(nil)).to be_nil
    end
  end

  describe '#fills_by_index' do
    it 'returns fill at given index' do
      expect(styles.fills_by_index(1)).to be_a OOXL::Fill
    end

    it 'returns nil for blank index' do
      expect(styles.fills_by_index(nil)).to be_nil
    end
  end

  describe '#number_formats_by_index' do
    it 'returns format code matching the id' do
      expect(styles.number_formats_by_index(164)).to eq '0.00'
      expect(styles.number_formats_by_index(165)).to eq 'mm/dd/yyyy'
    end

    it 'returns nil for non-existent id' do
      expect(styles.number_formats_by_index(999)).to be_nil
    end
  end
end
