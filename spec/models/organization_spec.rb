require "rails_helper"

RSpec.describe Organization, type: :model do
  it "is valid with name" do
    organization = build(:organization)
    expect(organization).to be_valid
  end
  it "is invalid without name" do
    organization = build(:organization, name: nil)
    organization.valid?
    expect(organization.errors[:name]).to include("can't be blank")
  end

  describe "Associations" do
    it "has and belongs to many players" do
      association = described_class.reflect_on_association(:players)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "players has to be unique" do
      organization = create(:organization)
      player = create(:player)
      expect { 2.times { organization.players.push(player) } }.to change(organization.players, :count).by(1)
    end
    it "has many events" do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_many
    end
    it "has many boardgames" do
      association = described_class.reflect_on_association(:boardgames)
      expect(association.macro).to eq :has_many
    end
    it "boardgames has to be unique" do
      organization = create(:organization)
      boardgame = create(:boardgame)
      expect { 2.times { organization.boardgames.push(boardgame) } }.to change(organization.boardgames, :count).by(1)
    end
    it "has many users" do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end
  end
end
