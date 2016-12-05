require 'rails_helper'

describe Boardgame do
  it "is valid with data and maxplayers" do
    boardgame = Boardgame.new(name: "Carcassonne", maxplayers: 5)
    expect(boardgame).to be_valid
  end
  it "is invalid without a name" do
    # boardgame = Boardgame.new(name: nil)
    boardgame = build(:boardgame, name: nil)
    boardgame.valid?
    expect(boardgame.errors[:name]).to include("can't be blank")
  end
  it "is invalid without maxplayers" do
    boardgame = Boardgame.new(maxplayers: nil)
    boardgame.valid?
    expect(boardgame.errors[:maxplayers]).to include("can't be blank")
  end
end
