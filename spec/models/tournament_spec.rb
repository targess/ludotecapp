require "rails_helper"

RSpec.describe Tournament, type: :model do
  it "is valid with name, date, max_competitors, valid event and valid participant" do
    tournament = build(:tournament)
    expect(tournament).to be_valid
  end
  it "is invalid without name" do
    tournament = build(:tournament, name: nil)
    tournament.valid?
    expect(tournament.errors[:name]).to include("can't be blank")
  end
  it "is invalid without date" do
    tournament = build(:tournament, date: nil)
    tournament.valid?
    expect(tournament.errors[:date]).to include("can't be blank")
  end
  it "is invalid without max_competitors" do
    tournament = build(:tournament, max_competitors: nil)
    tournament.valid?
    expect(tournament.errors[:max_competitors]).to include("can't be blank")
  end
  it "is invalid without max_substitutes" do
    tournament = build(:tournament, max_substitutes: nil)
    tournament.valid?
    expect(tournament.errors[:max_substitutes]).to include("can't be blank")
  end
  it "is invalid without event" do
    tournament = build(:tournament, event: nil)
    tournament.valid?
    expect(tournament.errors[:event]).to include("can't be blank")
  end
  it "is invalid without boardgame" do
    tournament = build(:tournament, boardgame: nil)
    tournament.valid?
    expect(tournament.errors[:boardgame]).to include("can't be blank")
  end
  it "max participants is equal to max competitors plus max substitutes" do
    tournament = create(:tournament, max_competitors: 5, max_substitutes: 1)
    expect(tournament.max_participants).to eq(6)
  end

  context "Event" do
    it "is valid with date into event date range" do
      event      = create(:event, start_date: "10/01/2016", end_date: "12/01/2016")
      tournament = build(:tournament, event: event, date: "11/01/2016")
      expect(tournament).to be_valid
    end
    it "is invalid with date before event date range" do
      event      = create(:event, start_date: "10/01/2016", end_date: "12/01/2016")
      tournament = build(:tournament, event: event, date: "9/01/2016")
      tournament.valid?
      expect(tournament.errors[:date]).to include("can't be before event start date")
    end
    it "is invalid with date after event date range" do
      event      = create(:event, start_date: "10/01/2016", end_date: "12/01/2016")
      tournament = build(:tournament, event: event, date: "13/01/2016")
      tournament.valid?
      expect(tournament.errors[:date]).to include("can't be afer event end date")
    end
  end

  context "Participants" do
    it "returns true when max participants are rearched" do
      tournament = create(:tournament, max_competitors: 1, max_substitutes: 0)
      create(:participant, tournament: tournament)
      expect(tournament.max_participants_rearched).to be_truthy
    end
    it "returns false when max participants arent rearched" do
      tournament = create(:tournament, max_competitors: 1, max_substitutes: 0)
      expect(tournament.max_participants_rearched).to be_falsey
    end
    it "assigned as competitor when slots available" do
      tournament = create(:tournament, max_competitors: 1, max_substitutes: 0)
      competitor = create(:participant, tournament: tournament)
      expect(tournament.competitors).to include(competitor)
    end
    it "assigned as substitute when no slots available" do
      tournament = create(:tournament, max_competitors: 1, max_substitutes: 1)
      create(:participant, tournament: tournament)
      substitute = create(:participant, tournament: tournament)
      expect(tournament.substitutes).to include(substitute)
    end
    it "assigned as confirmed when slots available and confirmed" do
      tournament = create(:tournament, max_competitors: 1, max_substitutes: 0)
      confirmed = create(:participant, tournament: tournament, confirmed: true)
      expect(tournament.confirmed).to include(confirmed)
    end
    pending "gives a list of league system rounds and matches from confirmed participants"
    pending "gives an empty list of participants for league system when not confirmed participants"
  end

  describe "Associations" do
    it "belongs to boardgame" do
      association = described_class.reflect_on_association(:boardgame)
      expect(association.macro).to eq :belongs_to
    end
    it "belongs to event" do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end
    it "has many participants" do
      association = described_class.reflect_on_association(:participants)
      expect(association.macro).to eq :has_many
    end
  end
end
