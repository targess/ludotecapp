require 'rails_helper'

RSpec.describe Participant, type: :model do
  it 'is valid with player and tournament' do
    participant = build(:participant)
    expect(participant).to be_valid
  end
  it 'is invalid without a valid tournament' do
    participant = build(:participant, tournament: nil)
    participant.valid?
    expect(participant.errors[:tournament]).to include("can't be blank")
  end
  it 'is invalid without a valid player' do
    participant = build(:participant, player: nil)
    participant.valid?
    expect(participant.errors[:player]).to include("can't be blank")
  end
  it 'confirmed participants are competitors' do
    competitor = build(:competitor)
    expect(competitor.confirmed).to be(true)
  end
  it 'can toggle from unconfirmed to confirmed' do
    participant = create(:participant, confirmed: false)
    participant.toggle_confirmed
    expect(participant.confirmed).to be(true)
  end
  it 'can toggle from confirmed to unconfirmed' do
    participant = create(:participant, confirmed: true)
    participant.toggle_confirmed
    expect(participant.confirmed).to be(false)
  end

  context 'player' do
    before(:each) do
      @tournament  = create(:tournament)
      @player      = create(:player)
    end
    it 'is valid with one participant at a tournament' do
      participant = build(:participant, tournament: @tournament, player: @player)
      expect(participant).to be_valid
    end
    it 'is invalid with more than whan participant at a tournament' do
      create(:participant, tournament: @tournament, player: @player)
      participant = build(:participant, tournament: @tournament, player: @player)
      participant.valid?
      expect(participant.errors[:player]).to include("has already been taken")
    end
  end

  context 'Tournament' do
    it 'is participant when max competitors arent rearched' do
      tournament  = create(:tournament, max_competitors: 1)
      participant = create(:participant, tournament: tournament)
      expect(participant.substitute).to be(false)
    end
    it 'is substitute when max competitors are rearched' do
      tournament  = create(:tournament, max_competitors: 1)
      create(:participant, tournament: tournament)
      participant = create(:participant, tournament: tournament)
      expect(participant.substitute).to be(true)
    end
    it 'can be stored if participants count is lower than max participants' do
      tournament  = create(:tournament, max_competitors: 1, max_substitutes: 0)
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant).to be_valid
    end
    it 'cant be stored if participants count is equal or higher than max participants' do
      tournament  = create(:tournament, max_competitors: 0, max_substitutes: 0)
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include("max participants are rearched")
    end

    it 'over minimal age can be inscribed' do
      Timecop.travel Time.parse("2/1/2020")
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: "2/1/2000")
      participant = build(:participant, player: player, tournament: tournament)
      expect(participant).to be_valid
      Timecop.return
    end
    it 'at minimal age can be inscribed' do
      Timecop.travel Time.parse("2/1/2020")
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: "2/1/2010")
      participant = build(:participant, player: player, tournament: tournament)
      expect(participant).to be_valid
      Timecop.return
    end
    it 'under minimal age cant be inscribed' do
      Timecop.travel Time.parse("2/1/2010")
      tournament  = create(:tournament, minage: 10)
      player      = create(:player, birthday: "2/1/2005")
      participant = build(:participant, player: player, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include ("player under minimal age")
      Timecop.return
    end
    it 'participants cant be added to future tournaments with deleted Boardgame' do
      Timecop.travel Time.parse("1/01/2016")
      boardgame   = create(:boardgame)
      event       = create(:event, start_date: "1/01/2016", end_date: "2/02/2016")
      tournament  = create(:tournament, event: event, boardgame: boardgame, date: "1/02/2016")
      boardgame.destroy
      participant = build(:participant, tournament: tournament)
      participant.valid?
      expect(participant.errors[:tournament]).to include('tournament with invalid boardgame')
      Timecop.return
    end
    pending 'cant be unsuscribed from past tournaments'
    pending 'are deleted when unsuscribed from future or present tournaments'
    pending 'is valid if are at same event'
    pending 'is invalid if arent in same event'
    pending 'is ready to compete when marked as confirmed'
    pending 'is not ready to compete when not marked as confirmed'
    pending 'confirmed matches at league sytems '
    pending 'if competitor deleted first substitute is a new competitor'
    pending 'fails when competitor deleted and first substitute isnt a new competitor'
  end

  describe 'Associations' do
    it 'belongs to players' do
      association = described_class.reflect_on_association(:player)
      expect(association.macro).to eq :belongs_to
    end
    it 'belongs to tournaments' do
      association = described_class.reflect_on_association(:tournament)
      expect(association.macro).to eq :belongs_to
    end
  end
end
