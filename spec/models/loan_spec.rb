require 'rails_helper'

RSpec.describe Loan, type: :model do
  it 'is invalid with returned date before created' do
    loan = build(:loan, created_at: '20/1/2016 11:23:17', returned_at: '10/1/2016 11:23:17')
    loan.valid?
    expect(loan.errors[:returned_at]).to include ("can't be before created_at")
  end
  it 'is valid with returned date after created' do
    loan = build(:loan, created_at: '1/1/2016 11:23:17', returned_at: '10/1/2016 11:23:17')
    expect(loan).to be_valid
  end
  it 'is valid with returned date equal created' do
    loan = build(:loan, created_at: '10/1/2016 11:23:17', returned_at: '10/1/2016 11:23:17')
    expect(loan).to be_valid
  end

  context 'players' do
    it 'is valid when player has all loans returned' do
      player    = create(:player)
      event     = create(:event)
      boardgame = create(:boardgame)
      loan      = build(:not_returned_loan, player: player, event: event, boardgame: boardgame)
      expect(loan).to be_valid
    end
    it 'is valid when player hasnt rearched max event concurrent loans' do
      player    = create(:player)
      event     = create(:event, loans_limits: 1 )
      boardgame = create(:boardgame, name: 'Los Colonos de Catan')
      loan 		= build(:not_returned_loan, player: player, event: event, boardgame: boardgame)

      expect(loan).to be_valid
    end
    it 'is invalid when player has rearched max event concurrent loans' do
      player    = create(:player)
      event     = create(:event, loans_limits: 1 )
      catan     = create(:boardgame, name: 'Los Colonos de Catan')
      create(:not_returned_loan, player: player, event: event, boardgame: catan)

      carcassonne = create(:boardgame, name: 'Carcassonne')
      loan        = build(:not_returned_loan, player: player, event: event, boardgame: carcassonne)
      loan.valid?
      expect(loan.errors[:player]).to include ('max loans rearched')
    end
    it 'is valid when max concurrent loans has no limits (is cero)' do
      player    = create(:player)
      event     = create(:event, loans_limits: 0 )
      boardgame = create(:boardgame)
      loan 		= build(:not_returned_loan, player: player, event: event, boardgame: boardgame)

      expect(loan).to be_valid
    end

  end

  context 'boardgames' do
    it 'new is invalid when has a no returned loans' do
      boardgame = create(:boardgame)
      create(:loan, boardgame: boardgame, returned_at: nil)

      loan = build(:not_returned_loan, boardgame: boardgame)
      loan.valid?
      expect(loan.errors[:boardgame]).to include('is invalid loan')
    end

    it 'return is valid when is the current loan' do
      Timecop.travel Time.parse("2/1/2016")
      boardgame = create(:boardgame)
      loan      = create(:not_returned_loan, boardgame: boardgame, created_at: '1/1/2016')
      loan.return
      expect(loan).to be_valid
      Timecop.return
    end

    it 'new is valid when has all loans returned' do
      boardgame = create(:boardgame)
      loan = build(:not_returned_loan, boardgame: boardgame)
      expect(loan).to be_valid
    end
  end

  describe 'Associations' do
    it 'belongs to events' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end
    it 'belongs to boardgames' do
      association = described_class.reflect_on_association(:boardgame)
      expect(association.macro).to eq :belongs_to
    end
    it 'belongs to players' do
      association = described_class.reflect_on_association(:player)
      expect(association.macro).to eq :belongs_to
    end
  end
end
