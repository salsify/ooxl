require 'spec_helper'

describe OOXL::Relationships do
  let(:relationships_xml) do
    <<~XML
      <Relationships>
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/customProperty" Target="../customProperty1.bin"/>
        <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing" Target="../drawings/drawing1.xml"/>
        <Relationship Id="rId6" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments" Target="../comments3.xml"/>
      </Relationships>
    XML
  end

  let(:relationships) { described_class.new(relationships_xml) }

  describe '#[]' do
    it 'finds relationship target by id' do
      expect(relationships['1']).to eq '../customProperty1.bin'
      expect(relationships['2']).to eq '../drawings/drawing1.xml'
      expect(relationships['6']).to eq '../comments3.xml'
    end

    it 'returns nil for non-existent id' do
      expect(relationships['99']).to be_nil
    end
  end

  describe '#by_type' do
    it 'returns targets for matching type' do
      expect(relationships.by_type('comments')).to eq ['../comments3.xml']
    end

    it 'returns empty array for non-matching type' do
      expect(relationships.by_type('hyperlink')).to eq []
    end
  end

  describe '#comment_id' do
    it 'extracts comment file number' do
      expect(relationships.comment_id).to eq '3'
    end

    it 'returns nil when no comments relationship' do
      no_comments_xml = <<~XML
        <Relationships>
          <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing" Target="../drawings/drawing1.xml"/>
        </Relationships>
      XML
      rels = described_class.new(no_comments_xml)
      expect(rels.comment_id).to be_nil
    end
  end
end
