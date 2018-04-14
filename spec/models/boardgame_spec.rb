require "rails_helper"

describe Boardgame do
  it "is valid with data and maxplayers" do
    boardgame = build(:boardgame, maxplayers: 5)
    expect(boardgame).to be_valid
  end
  it "is invalid without a name" do
    boardgame = build(:boardgame, name: nil)
    boardgame.valid?
    expect(boardgame.errors[:name]).to include("can't be blank")
  end
  it "is invalid without maxplayers" do
    boardgame = build(:boardgame, maxplayers: nil)
    boardgame.valid?
    expect(boardgame.errors[:maxplayers]).to include("can't be blank")
  end

  it "is invalid with higher than 13 numbers barcode" do
    boardgame = build(:boardgame, barcode: "1234557890")
    boardgame.valid?
    expect(boardgame.errors[:barcode]).to include("is the wrong length (should be 13 characters)")
  end
  it "is invalid with higher than 5 chars internalcode" do
    boardgame = build(:boardgame, internalcode: "1234")
    boardgame.valid?
    expect(boardgame.errors[:internalcode]).to include("is the wrong length (should be 5 characters)")
  end
  it "is invalid without organization" do
    boardgame = build(:boardgame, organization: nil)
    boardgame.valid?
    expect(boardgame.errors[:organization]).to include("can't be blank")
  end

  context "search coincidences" do
    before(:each) do
      @carcassonne = create(:boardgame, name: "Carcassonne", barcode: "2222222222222", internalcode: "QJ001")
      @catan       = create(:boardgame, name: "Catan", barcode: "1111111111111", internalcode: "QJ002")
      @aventureros = create(:boardgame, name: "Aventureros", barcode: "2222222233333", internalcode: "QJ003")
      @event       = create(:event)
    end
    it "returns boardgames that name includes search text" do
      expect(Boardgame.search_by_name("Ca")).to include(@carcassonne, @catan)
    end
    it "returns boardgame if barcode with match exact" do
      expect(Boardgame.search_by_barcode("2222222233333")).to include(@aventureros)
    end
    it "returns boardgame if internalcode with match exact" do
      expect(Boardgame.search_by_internalcode("QJ001")).to include(@carcassonne)
    end
    it "returns boardgames by name at selected event" do
      @event.boardgames.push(@carcassonne)
      expect(@event.boardgames.search_by_name("Ca")).to include(@carcassonne)
    end
    it "not returns boardgame by name if not included at selected event" do
      expect(@event.boardgames.search_by_name("Ca")).not_to include(@carcassonne)
    end
    it "returns boardgame if barcode with match exact at selected event" do
      @event.boardgames.push(@aventureros)
      expect(@event.boardgames.search_by_barcode("2222222233333")).to include(@aventureros)
    end
    it "not returns boardgame by barcode if not included at selected event" do
      expect(@event.boardgames.search_by_barcode("2222222233333")).not_to include(@aventureros)
    end
    it "returns boardgame if internalcode with match exact at selected event" do
      @event.boardgames.push(@aventureros)
      expect(@event.boardgames.search_by_internalcode("QJ003")).to include(@aventureros)
    end
    it "not returns boardgame by internalcode if not included at selected event" do
      expect(@event.boardgames.search_by_internalcode("QJ003")).not_to include(@aventureros)
    end
  end

  context "Loans" do
    before(:each) do
      @boardgame = create(:boardgame)
      @event     = create(:event)
    end

    it "returns not returned loans from an event" do
      loan = create(:not_returned_loan, boardgame: @boardgame, event: @event)
      expect(@boardgame.active_loans).to eq([loan])
    end

    it "returns empty array if in case all loans returned" do
      create(:loan, boardgame: @boardgame, event: @event)
      expect(@boardgame.active_loans).to eq([])
    end
  end

  context "Associations" do
    it "has and belongs to many events" do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "has many loans" do
      association = described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
    it "has many tournaments" do
      association = described_class.reflect_on_association(:tournaments)
      expect(association.macro).to eq :has_many
    end
    it "belongs to organization" do
      association = described_class.reflect_on_association(:organization)
      expect(association.macro).to eq :belongs_to
    end
  end

  context "Event" do
    before(:each) do
      @boardgame = create(:boardgame)
      @event     = create(:event)
    end

    pending "add boardgame to event"
    pending "delete boardgame from event"
  end

  context "deleted" do
    before(:each) do
      @boardgame = create(:boardgame)
      create(:loan, boardgame: @boardgame)
      create(:tournament, boardgame: @boardgame)
    end
    it "is setted when we try to destroy it" do
      @boardgame.destroy
      expect(@boardgame.deleted_at).to be_truthy
    end
    it "fails to be setted when arent market to destroy" do
      expect(@boardgame.deleted_at).not_to be_truthy
    end
    it "is valid when internal code is setted as DELETED" do
      @boardgame.destroy
      expect(@boardgame.internalcode).to include("DEL")
    end
    it "cant be displayed at boardgames lists" do
      expect { @boardgame.destroy }.to change(Boardgame, :count).by(-1)
    end
    it "cant be loaned" do
      @boardgame.destroy
      expect(@boardgame.deleted_at?).to eq(true)
    end
    it "past tournaments are displayed" do
      @boardgame.destroy
      tournament = build(:tournament, boardgame: @boardgame, date: 1.days.from_now)
      expect(tournament).to be_valid
    end
    it "at loans lists can be displayed" do
      loan = create(:loan, boardgame: @boardgame)
      @boardgame.destroy
      expect(Loan.all).to include(loan)
    end
    it "cant be deleted with active loans" do
      create(:not_returned_loan, boardgame: @boardgame)
      expect { @boardgame.destroy }.not_to change(Boardgame, :count)
    end
    it "are counted at past event boardgames counts" do
      event = create(:event)
      event.boardgames.push(@boardgame)
      expect { @boardgame.destroy }.not_to change(event.boardgames.with_deleted, :count)
    end
    it "is hard deleted when has no one loans nor tournaments" do
      boardgame = create(:boardgame)
      expect { boardgame.destroy }.to change(Boardgame.with_deleted, :count).by(-1)
    end
  end
end
