require "rails_helper"

RSpec.describe Event, type: :model do
  it "is valid with name, start and end date" do
    event = build(:event, name: "Mi evento", start_date: "10/1/2016", end_date: "12/1/2016")
    expect(event).to be_valid
  end
  it "is invalid without name" do
    event = build(:event, name: nil)
    event.valid?
    expect(event.errors[:name]).to include("can't be blank")
  end
  it "is invalid without start date" do
    event = build(:event, start_date: nil)
    event.valid?
    expect(event.errors[:start_date]).to include("can't be blank")
  end
  it "is invalid without end date" do
    event = build(:event, end_date: nil)
    event.valid?
    expect(event.errors[:end_date]).to include("can't be blank")
  end
  it "is valid with start date before end date" do
    event = build(:event, start_date: "10/1/2016", end_date: "12/1/2016")
    expect(event).to be_valid
  end
  it "is valid with start date equal to end date" do
    event = build(:event, start_date: "10/1/2016", end_date: "10/1/2016")
    expect(event).to be_valid
  end
  it "is invalid with start date after end date" do
    event = build(:event, start_date: "20/1/2016", end_date: "10/1/2016")
    event.valid?
    expect(event.errors[:start_date]).to include("can't be after end_date")
  end

  describe "Associations" do
    it "has and belongs to many boardgames" do
      association = described_class.reflect_on_association(:boardgames)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "boardgames has to be unique" do
      event     = create(:event, start_date: "10/1/2016", end_date: "20/1/2016")
      boardgame = create(:boardgame)
      expect { 2.times { event.boardgames.push(boardgame) } }.to change(event.boardgames, :count).by(1)
    end
    it "has and belongs to many players" do
      association = described_class.reflect_on_association(:players)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "players has to be unique" do
      event  = create(:event, start_date: "10/1/2016", end_date: "20/1/2016")
      player = create(:player)
      expect { 2.times { event.players.push(player) } }.to change(event.players, :count).by(1)
    end
    it "has many loans" do
      association = described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
    it "has many tournaments" do
      association = described_class.reflect_on_association(:tournaments)
      expect(association.macro).to eq :has_many
    end
  end
end
