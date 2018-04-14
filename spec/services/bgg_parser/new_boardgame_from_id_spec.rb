require 'rails_helper'

RSpec.describe BggParser::NewBoardgameFromIdService do
  describe 'Get from bgg id' do
    it 'returns a hash when inputs a valid integer' do
      get_boardgame = BggParser::NewBoardgameFromIdService.perform("1")
      expect(get_boardgame).to be_a_kind_of(Boardgame)
    end
    it 'returns nil when input an overhead integer' do
      get_boardgame = BggParser::NewBoardgameFromIdService.perform("999999999999999")
      expect(get_boardgame).to be {}
    end
    it 'returns nil when input an invalid value' do
      get_boardgame = BggParser::NewBoardgameFromIdService.perform("invalid")
      expect(get_boardgame).to be {}
    end
  end
end
