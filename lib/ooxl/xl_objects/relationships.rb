class OOXL
  class Relationships
    SUPPORTED_TYPES = ['http://schemas.openxmlformats.org/officeDocument/2006/relationships/comments'].freeze

    def initialize(relationships_node)
      @relationships = []
      parse_relationships(relationships_node)
    end

    def comment_id
      comment_target = by_type('comments').first
      comment_target && extract_file_reference(comment_target)
    end

    def [](id)
      @relationships.find { |rel| rel.id == id }&.target
    end

    def by_type(type)
      @relationships.select { |rel| rel.type == type }.map(&:target)
    end

    private

    def parse_relationships(relationships_node)
      relationships_node = Nokogiri.XML(relationships_node).remove_namespaces!
      relationships_node.xpath('//Relationship').each do |relationship_node|
        relationship_type = relationship_node.attributes['Type'].value
        relationship_node.attributes['Target'].value
        id = extract_number(relationship_node.attributes['Id'].value)
        type = extract_type(relationship_type)
        target = relationship_node.attributes['Target'].value
        @relationships << Relationship.new(id, type, target)
      end
    end

    def extract_number(str)
      str.scan(/(\d+)/).flatten.first
    end

    def extract_type(type)
      type.split('/').last
    end

    def extract_file_reference(file)
      file.scan(/(\d+)\.\w/).flatten.first
    end

    Relationship = Struct.new(:id, :type, :target) # rubocop:disable Lint/UselessConstantScoping
  end
end
