require 'spec_helper'

describe OOXL::Table do
  let(:table_xml) do
    <<~XML
      <table name="SalesData" ref="A1:D10" displayName="SalesData">
        <tableColumns count="4">
          <tableColumn id="1" name="Region"/>
          <tableColumn id="2" name="Sales"/>
          <tableColumn id="3" name="Profit"/>
          <tableColumn id="4" name="Year"/>
        </tableColumns>
      </table>
    XML
  end

  let(:table) { described_class.new(table_xml) }

  describe '#name' do
    it 'returns the table name' do
      expect(table.name).to eq 'SalesData'
    end
  end

  describe '#ref' do
    it 'returns the table reference range' do
      expect(table.ref).to eq 'A1:D10'
    end
  end
end
