require 'rails_helper'

RSpec.describe BggParser::GetCollectionService do
  describe 'Search BGG Collection' do
    it 'returns an array when request a valid collection' do
      get_collection = BggParser::GetCollectionService.perform('targess')
      expect(get_collection).to be_a_kind_of(Array)
    end
    it 'returns an empty array when collection not found' do
      get_collection = BggParser::GetCollectionService.perform('sksdjfñklasdjn')
      expect(get_collection).to eq([])
    end
  end
end
