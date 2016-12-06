require 'rails_helper'

describe Boardgame do
  it 'is valid with data and maxplayers' do
    boardgame = Boardgame.new(name: "Carcassonne", maxplayers: 5)
    expect(boardgame).to be_valid
  end
  it 'is invalid without a name' do
    # boardgame = Boardgame.new(name: nil)
    boardgame = build(:boardgame, name: nil)
    boardgame.valid?
    expect(boardgame.errors[:name]).to include("can't be blank")
  end
  it 'is invalid without maxplayers' do
    boardgame = Boardgame.new(maxplayers: nil)
    boardgame.valid?
    expect(boardgame.errors[:maxplayers]).to include("can't be blank")
  end

  context 'BggParser' do
    describe 'Search a boardgame' do
      it 'returns an array when does a valid search' do
        search = Boardgame.bgg_search_by_name('los colonos de catan')
        expect(search).to be_a_kind_of(Array)
      end
      it 'returns an empty array when gives an empty or whitespaces string search' do
        search = Boardgame.bgg_search_by_name(' ')
        expect(search).to eq([])
      end
    end
    describe 'Get from bgg id' do
      it 'returns a hash when inputs a valid integer' do
        get_boardgame = Boardgame.bgg_get_by_id('1')
        expect(get_boardgame).to be_a_kind_of(Hash)
      end
      it 'returns nil when input an overhead integer' do
        get_boardgame = Boardgame.bgg_get_by_id('999999999999999')
        expect(get_boardgame).to be nil
      end
      it 'returns nil when input an invalid value' do
        get_boardgame = Boardgame.bgg_get_by_id('invalid')
        expect(get_boardgame).to be nil
      end
    end
    describe 'Search BGG Collection' do
      it 'returns an array when request a valid collection' do
        get_collection = Boardgame.bgg_get_collection('targess')
        expect(get_collection).to be_a_kind_of(Array)
      end
      pending 'returns an array with status 202 when recibes a 202 response'

      it 'returns an empty array when collection not found' do
        get_collection = Boardgame.bgg_get_collection('sksdjfñklasdjnxcvaksñfn')
        expect(get_collection).to eq([])

      end
    end
  end
  context 'Import from BGG' do
    pending '#create_from_bgg_id'
    pending '#import_from_bgg_collection'
  end
end
