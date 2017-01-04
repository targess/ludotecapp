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

  context "BggParser" do
    describe "Search a boardgame" do
      it "returns an array when does a valid search" do
        search = Boardgame.bgg_search_by_name("los colonos de catan")
        expect(search).to be_a_kind_of(Array)
      end
      it "returns an empty array when gives an empty or whitespaces string search" do
        search = Boardgame.bgg_search_by_name(" ")
        expect(search).to eq([])
      end
      it "returns an empty array when gives less than four chars search" do
        search = Boardgame.bgg_search_by_name("123")
        expect(search).to eq([])
      end
    end

    describe "Get from bgg id" do
      it "returns a hash when inputs a valid integer" do
        get_boardgame = Boardgame.bgg_get_by_id("1")
        expect(get_boardgame).to be_a_kind_of(Hash)
      end
      it "returns nil when input an overhead integer" do
        get_boardgame = Boardgame.bgg_get_by_id("999999999999999")
        expect(get_boardgame).to be nil
      end
      it "returns nil when input an invalid value" do
        get_boardgame = Boardgame.bgg_get_by_id("invalid")
        expect(get_boardgame).to be nil
      end
    end

    describe "Search BGG Collection" do
      it "returns an array when request a valid collection" do
        get_collection = Boardgame.bgg_get_collection("targess")
        expect(get_collection).to be_a_kind_of(Array)
      end
      it "returns an empty array when collection not found" do
        get_collection = Boardgame.bgg_get_collection("sksdjfñklasdjnxcvaksñfn")
        expect(get_collection).to eq([])
      end
    end
  end

  context "Import from BGG" do
    pending "#new_from_bgg_id"
    pending "#import_from_bgg_collection"
  end

  context "Loans" do
    before(:each) do
      @boardgame = create(:boardgame)
      @event     = create(:event)
    end
    it "returns true state (free) when all loans returned" do
      expect(@boardgame.free_to_loan?).to eq(true)
    end
    it "returns false state (loaned) when has an active loan" do
      create(:not_returned_loan, boardgame: @boardgame, event: @event)
      expect(@boardgame.free_to_loan?).to eq(false)
    end

    it "returns not returned loans from an event" do
      loan = create(:not_returned_loan, boardgame: @boardgame, event: @event)
      expect(@boardgame.active_loans(@event)).to eq([loan])
    end

    it "returns empty array if in case all loans returned" do
      create(:loan, boardgame: @boardgame, event: @event)
      expect(@boardgame.active_loans(@event)).to eq([])
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
  end

  context "Event" do
    before(:each) do
      @boardgame = create(:boardgame)
      @event     = create(:event)
    end
    it "is present in current event" do
      @event.boardgames.push(@boardgame)
      expect(@boardgame.at_event?(@event)).to be_truthy
    end
    it "isnt present in current event" do
      expect(@boardgame.at_event?(@event)).not_to be_truthy
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
      tournament = build(:tournament, boardgame: @boardgame, date: "11/01/2016")
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
