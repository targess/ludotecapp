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
  it 'is valid with event, boardgame and player' do
      loan = build(:loan)
      expect(loan).to be_valid
  end
  it 'is invalid without event' do
      loan = build(:loan, event: nil)
      loan.valid?
      expect(loan.errors[:event]).to include("can't be blank")
  end
  it 'is invalid without boardgame' do
      loan = build(:loan, boardgame: nil)
      loan.valid?
      expect(loan.errors[:boardgame]).to include("can't be blank")
  end
  it 'is invalid without player' do
      loan = build(:loan, player: nil)
      loan.valid?
      expect(loan.errors[:player]).to include("can't be blank")
  end

  pending 'returns a list of loans by date, with not returned_at first (ordered_loans)'

  context 'players' do
    before(:each) do
      @player    = create(:player)
      @boardgame = create(:boardgame)
    end
    it 'is valid when player has all loans returned' do
      event     = create(:event)
      loan      = build(:not_returned_loan, player: @player, event: event, boardgame: @boardgame)
      expect(loan).to be_valid
    end
    it 'is valid when player hasnt rearched max event concurrent loans' do
      event     = create(:event, loans_limits: 1 )
      loan 		  = build(:not_returned_loan, player: @player, event: event, boardgame: @boardgame)
      expect(loan).to be_valid
    end
    it 'is invalid when player has rearched max event concurrent loans' do
      event     = create(:event, loans_limits: 1 )
      create(:not_returned_loan, player: @player, event: event, boardgame: @boardgame)

      catan       = create(:boardgame, name: 'Los Colonos de Catan')
      loan        = build(:not_returned_loan, player: @player, event: event, boardgame: catan)
      loan.valid?
      expect(loan.errors[:player]).to include ('max loans rearched')
    end
    it 'is valid when max concurrent loans has no limits (is cero)' do
      event     = create(:event, loans_limits: 0 )
      loan 		  = build(:not_returned_loan, player: @player, event: event, boardgame: @boardgame)
      expect(loan).to be_valid
    end
  end

  context 'boardgames' do
    before(:each) do
      @boardgame  = create(:boardgame)
    end
    it 'new is invalid when has a no returned loan at event' do
      event      = create(:event)
      loan_first = create(:loan, boardgame: @boardgame, event: event, returned_at: nil)

      loan       = build(:not_returned_loan, boardgame: @boardgame, event: event)
      loan.valid?
      expect(loan.errors[:boardgame]).to include("can't be loaned if boardgame not available")
    end

    it 'return is valid when is the current loan' do
      Timecop.travel Time.parse("2/1/2016")
      loan      = create(:not_returned_loan, boardgame: @boardgame, created_at: '1/1/2016')
      loan.return
      expect(loan).to be_valid
      Timecop.return
    end

    it 'new is valid when has all loans returned' do
      loan = build(:not_returned_loan, boardgame: @boardgame)
      expect(loan).to be_valid
    end

    pending 'cant be loaned or added to event if has present loan on another event'
    pending 'returns boardgames coincidences if name includes search text'
    pending 'returns boardgame coincidence with search text if barcode with match exact'
    pending 'returns boardgame coincidence with search text if internalcode with match exact'
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
