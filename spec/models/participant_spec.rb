require "rails_helper"

RSpec.describe Participant, type: :model do
  it "is valid with player and tournament" do
    participant = build(:participant)
    expect(participant).to be_valid
  end
  it "is invalid without a valid tournament" do
    participant = build(:participant, tournament: nil)
    participant.valid?
    expect(participant.errors[:tournament]).to include("can't be blank")
  end
  it "is invalid without a valid player" do
    participant = build(:participant, player: nil)
    participant.valid?
    expect(participant.errors[:player]).to include("can't be blank")
  end
  it "can toggle from unconfirmed to confirmed" do
    participant = create(:participant, confirmed: false)
    participant.toggle_confirmed
    expect(participant.confirmed).to be(true)
  end
  it "can toggle from confirmed to unconfirmed" do
    participant = create(:participant, confirmed: true)
    participant.toggle_confirmed
    expect(participant.confirmed).to be(false)
  end

  context "player" do
    before(:each) do
      @tournament  = create(:tournament)
      @player      = create(:player)
    end
    it "is valid with one participant at a tournament" do
      participant = build(:participant, tournament: @tournament, player: @player)
      expect(participant).to be_valid
    end
    it "is invalid with more than whan participant at a tournament" do
      create(:participant, tournament: @tournament, player: @player)
      participant = build(:participant, tournament: @tournament, player: @player)
      participant.valid?
      expect(participant.errors[:player]).to include("has already been taken")
    end
  end

  context "Tournament" do
    it "is participant when max competitors arent rearched" do
      tournament  = create(:tournament, max_competitors: 1)
      participant = create(:participant, tournament: tournament)
      expect(participant.substitute).to be(false)
    end
    it "is substitute when max competitors are rearched" do
      tournament = create(:tournament, max_competitors: 1)
      create(:participant, tournament: tournament)
      participant = create(:participant, tournament: tournament)
      expect(participant.substitute).to be(true)
    end
    it "can be stored if participants count is lower than max participants" do
      tournament  = create(:tournament, max_competitors: 1, max_substitutes: 0)
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant).to be_valid
    end
    it "cant be stored if participants count is equal or higher than max participants" do
      tournament  = create(:tournament, max_competitors: 0, max_substitutes: 0)
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include("max participants are rearched")
    end
    it "over minimal age can be inscribed" do
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: 20.years.ago)
      participant = build(:participant, player: player, tournament: tournament)
      expect(participant).to be_valid
    end
    it "at minimal age can be inscribed" do
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: 10.years.ago)
      participant = build(:participant, player: player, tournament: tournament)
      expect(participant).to be_valid
    end
    it "under minimal age cant be inscribed" do
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: 5.years.ago)
      participant = build(:participant, player: player, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include("player under minimal age")
    end
    it "participants cant be added to future tournaments with deleted Boardgame" do
      boardgame   = create(:boardgame)
      event       = create(:event)
      tournament  = create(:tournament, event: event, boardgame: boardgame)
      boardgame.destroy
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include("tournament with invalid boardgame")
    end
    it "participant belongs to future tournament" do
      boardgame   = create(:boardgame)
      event       = create(:event)
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: 1.days.from_now)
      participant = create(:participant, tournament: tournament)
      expect(participant.at_future_tournament?).to be_truthy
    end
    it "participant belongs to started tournament" do
      boardgame   = create(:boardgame)
      event       = create(:event)
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: 1.hours.from_now)
      participant = create(:participant, tournament: tournament)
      Timecop.travel 1.days.from_now
        expect(participant.at_future_tournament?).to be_falsey
      Timecop.return
    end
    it "cant be unsuscribed from past tournaments" do
      boardgame   = create(:boardgame)
      event       = create(:event, start_date: 10.days.ago, end_date: 10.days.from_now)
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: 1.days.ago)
      Timecop.travel 2.days.ago
        participant = create(:participant, tournament: tournament)
      Timecop.return
      expect { participant.destroy }.not_to change(Participant, :count)
      expect(participant.errors[:tournament]).to include("Cannot delete participant from past tournament")
    end
    it "are deleted when unsuscribed from future tournaments" do
      boardgame   = create(:boardgame)
      event       = create(:event)
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: 1.days.from_now)
      participant = create(:participant, tournament: tournament)
      expect { participant.destroy }.to change(Participant, :count).by(-1)
    end
    it "are deleted when unsuscribed from present tournaments" do
      boardgame   = create(:boardgame)
      event       = create(:event)
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: 1.hours.from_now)
      participant = create(:participant, tournament: tournament)
      expect { participant.destroy }.to change(Participant, :count).by(-1)
    end
    it "is valid if are at same event" do
      player      = create(:player)
      event       = create(:event)
      event.players << player
      tournament  = create(:tournament, event: event)
      participant = build(:participant, player: player, tournament: tournament)
      expect(participant).to be_valid
    end
    pending "is invalid if arent in same event" do
      player      = create(:player)
      event       = create(:event)
      tournament  = create(:tournament, event: event)
      participant = build(:participant, player: player, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include("belongs to another event")
    end
    it "if competitor deleted first substitute is a new competitor" do
      event      = create(:event)
      tournament = create(:tournament, max_competitors: 1, event: event)
      competitor = create(:participant, tournament: tournament)
      create(:participant, tournament: tournament)
      expect { competitor.destroy }.to change(tournament.substitutes, :count).by(-1)
    end
    pending "confirmed matches at league sytems"
  end

  describe "Associations" do
    it "belongs to players" do
      association = described_class.reflect_on_association(:player)
      expect(association.macro).to eq :belongs_to
    end
    it "belongs to tournaments" do
      association = described_class.reflect_on_association(:tournament)
      expect(association.macro).to eq :belongs_to
    end
  end
end
