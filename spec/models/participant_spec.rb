require 'rails_helper'

RSpec.describe Participant, type: :model do
  it 'is valid with player and event' do
    participant = build(:participant)
    expect(participant).to be_valid
  end
  it 'is invalid without a valid event' do
    participant = build(:participant, event: nil)
    participant.valid?
    expect(participant.errors[:event]).to include("can't be blank")
  end
  it 'is invalid without a valid player' do
    participant = build(:participant, player: nil)
    participant.valid?
    expect(participant.errors[:player]).to include("can't be blank")
  end
  it 'confirmed participants are competitors' do
    competitor = build(:competitor)
    expect(competitor.confirmed).to be_true
  end

  context 'Tournament' do
    it 'is valid if are in same event' do
      event       = create(:event)
      tournament  = create(:tournament, event: event)
      player      = create(:player, event: event)
      participant = build(:participant, player: player)
      expect(participant).to be_valid
    end
    it 'is invalid if arent in same event' do
      event       = create(:event)
      tournament  = create(:tournament, event: event)
      player      = create(:player)
      participant = build(:participant, player: player)
      expect(participant).to include("can't be added into tournament for not subscribed event")
    end
    it 'is participant when max competitors arent rearched' do
      tournament = create(:tournament, max_competitors: 1)
      participant = create(:participant, tournament: tournament)
      expect(participant.substitute).to be_false
    end
    it 'is supplent when max competitors are rearched' do
      tournament = create(:tournament, max_competitors: 1)
      create(:participant, tournament: tournament)
      supplent = create(:participant, tournament: tournament)
      expect(supplent.substitute).to be_true
    end
    pending 'is ready to compete when marked as confirmed'
    pending 'is not ready to compete when not marked as confirmed'
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
