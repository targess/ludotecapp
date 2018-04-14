require 'rails_helper'

RSpec.describe BggParser::SearchBoardgameByNameService do
  describe 'Search a boardgame' do
    it 'returns an array when does a valid search' do
      search = BggParser::SearchBoardgameByNameService.perform('los colonos de catan')
      expect(search).to be_a_kind_of(Array)
    end
    it 'returns an empty array when gives empty or whitespace string search' do
      search = BggParser::SearchBoardgameByNameService.perform(' ')
      expect(search).to eq([])
    end
    it 'returns an empty array when gives less than four chars search' do
      search = BggParser::SearchBoardgameByNameService.perform('123')
      expect(search).to eq([])
    end
  end
end
