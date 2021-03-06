require "rails_helper"

RSpec.describe Player, type: :model do
  it "is valid with dni, firstname and lastname" do
    player = build(:player, dni: "48960950E", firstname: "Manolete", lastname: "El del Bombo")
    expect(player).to be_valid
  end
  it "is invalid without firstname" do
    player = build(:player, firstname: nil)
    player.valid?
    expect(player.errors[:firstname]).to include("can't be blank")
  end
  it "is invalid without lastname" do
    player = build(:player, lastname: nil)
    player.valid?
    expect(player.errors[:lastname]).to include("can't be blank")
  end
  it "returns a name with firstname and lastname as string" do
    player = build(:player, firstname: "Manolete", lastname: "El del Bombo")
    expect(player.name).to eq("Manolete El del Bombo")
  end
  it "returns dni plus name with dni, firsname and lastname as string" do
    player = build(:player, firstname: "Manolete", lastname: "El del Bombo", dni: "48960950E")
    expect(player.dni_plus_name).to eq("48960950E | Manolete El del Bombo")
  end
  it "returns age when has a valid birthday" do
    player = build(:player, birthday: 35.years.ago)
    expect(player.age).to eq(35)
  end
  it "returns empty string when has no birthday" do
    player = build(:player, birthday: nil)
    expect(player.age).to eq("")
  end
  pending "is invalid without organization" do
    player = build(:player, organization: nil)
    player.valid?
    expect(player.errors[:organization]).to include("can't be blank")
  end

  context "DNI" do
    it "is invalid without it" do
      player = build(:player, dni: "")
      player.valid?
      expect(player.errors[:dni]).to include("can't be blank")
    end
    it "is invalid with less than nine chars" do
      player = build(:player, dni: "12345678")
      player.valid?
      expect(player.errors[:dni]).to include("is invalid NIF/NIE")
    end
    it "is invalid with more than nine chars" do
      player = build(:player, dni: "1234567890")
      player.valid?
      expect(player.errors[:dni]).to include("is invalid NIF/NIE")
    end
    it "is invalid without letter in last char" do
      player = build(:player, dni: "123456789")
      player.valid?
      expect(player.errors[:dni]).to include("is invalid NIF/NIE")
    end
    it "has valid NIF format" do
      player = build(:player, dni: "48960950E")
      expect(player).to be_valid
    end
    it "has valid NIE format" do
      player = build(:player, dni: "x1234123n")
      expect(player).to be_valid
    end
    it "is invalid with incorrect format" do
      player = build(:player, dni: "48960950A")
      player.valid?
      expect(player.errors[:dni]).to include("is invalid NIF/NIE")
    end
    it "is invalid if with duplicates" do
      create(:player, firstname: "Jose", dni: "48960950E")
      player = build(:player, firstname: "Manolete", dni: "48960950E")
      player.valid?
      expect(player.errors[:dni]).to include("has already been taken")
    end
  end

  context "email" do
    it "has valid format" do
      player = build(:player, email: "joselito@gmail.com")
      expect(player).to be_valid
    end
    it "is invalid without correct format" do
      player = build(:player, email: "joselito@gmailcom")
      player.valid?
      expect(player.errors[:email]).to include("is invalid")
    end
    it "is invalid with duplicates" do
      create(:player, firstname: "jose", email: "joselito@gmail.com")
      player = build(:player, firstname: "manolete", email: "joselito@gmail.com")
      player.valid?
      expect(player.errors[:email]).to include("has already been taken")
    end
  end

  context "phone" do
    it "is invalid with less than nine numbers" do
      player = build(:player, phone: "65432178")
      player.valid?
      expect(player.errors[:phone]).to include("is the wrong length (should be 9 characters)")
    end
    it "is invalid with more than nine numbers" do
      player = build(:player, phone: "1234567890")
      player.valid?
      expect(player.errors[:phone]).to include("is the wrong length (should be 9 characters)")
    end
    it "is valid with nine numbers" do
      player = build(:player, phone: "987654321")
      expect(player).to be_valid
    end
  end

  context "loans" do
    it "returns active loans number" do
      player = create(:player)
      create(:not_returned_loan, player: player)
      expect(player.active_loans.count).to eq(1)
    end
  end

  context "deleted" do
    before(:each) do
      @player = create(:player)
      create(:loan, player: @player)
    end
    it "is setted when we try to destroy it" do
      @player.destroy
      expect(@player.deleted_at).to be_truthy
    end
    it "fails to be setted when arent marked to destroy" do
      expect(@player.deleted_at).to be_falsey
    end
    it "is valid when firstname changes to DELETED" do
      @player.destroy
      expect(@player.firstname).to include("DEL")
    end
    it "is valid when lastname changes to DELETED" do
      @player.destroy
      expect(@player.lastname).to include("DEL")
    end
    it "is valid when email changes to DELETED" do
      @player.destroy
      expect(@player.email).to include("DEL")
    end
    it "is valid when DNI changes to DELETED" do
      @player.destroy
      expect(@player.dni).to include("DEL")
    end
    it "cant be displayed at players lists" do
      expect { @player.destroy }.to change(Player, :count).by(-1)
    end
    it "at loans lists can be displayed" do
      loan = create(:loan, player: @player)
      @player.destroy
      expect(Loan.all).to include(loan)
    end
    it "cant be deleted with active loans" do
      create(:not_returned_loan, player: @player)
      expect { @player.destroy }.not_to change(Player, :count)
    end
    it "are counted at past event players count" do
      event = create(:event)
      event.players.push(@player)
      expect { @player.destroy }.not_to change(event.players.with_deleted, :count)
    end
    it "is hard deleted when has no one loans nor events" do
      empty_player = create(:player)
      expect { empty_player.destroy }.to change(Player.with_deleted, :count).by(-1)
    end
    it "is removed from participants at future tournaments" do
      event       = create(:event)
      tournament  = create(:tournament, event: event, date: 1.days.from_now)
      participant = create(:participant, tournament: tournament, player: @player)
      @player.destroy
      expect(Participant.all).not_to include(participant)
    end
    it "isnt removed from participants at past tournaments" do
      event       = create(:event)
      tournament  = create(:tournament, event: event, date: 1.days.ago)
      Timecop.travel 2.days.ago
      participant = create(:participant, tournament: tournament, player: @player)
      Timecop.return
      @player.destroy
      expect(Participant.all).to include(participant)
    end
  end

  describe "Associations" do
    it "has and belongs to many events" do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "has many loans" do
      association = described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
    it "has many participants" do
      association = described_class.reflect_on_association(:participants)
      expect(association.macro).to eq :has_many
    end
    it "has and belongs to many organizations" do
      association = described_class.reflect_on_association(:organizations)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it "players has to be unique" do
      organization = create(:organization)
      player = create(:player)
      expect { 2.times { player.organizations.push(organization) } }.to change(player.organizations, :count).by(1)
    end
  end
end
