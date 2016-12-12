require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'is valid with dni, firstname and lastname' do
    player = build(:player, dni: '48960950E', firstname: 'Manolete', lastname: 'El del Bombo')
    expect(player).to be_valid
  end
  it 'is invalid without firstname' do
    player = build(:player, firstname: nil)
    player.valid?
    expect(player.errors[:firstname]).to include ("can't be blank")
  end
  it 'is invalid without lastname' do
    player = build(:player, lastname: nil)
    player.valid?
    expect(player.errors[:lastname]).to include ("can't be blank")
  end
  it 'returns a name with firstname and lastname as string' do
    player = build(:player, firstname: "Manolete", lastname: "El del Bombo")
    expect(player.name).to eq("Manolete El del Bombo")
  end

  it 'returns age when has a valid birthday' do
    Timecop.travel Time.parse("7/12/2016")
    player = build(:player, birthday: "19/04/1981")
    expect(player.age).to eq(35)
    Timecop.return
  end

  it 'returns empty string when has no birthday' do
    player = build(:player, birthday: nil)
    expect(player.age).to eq("")
  end

  context 'DNI' do
    it 'is invalid without it' do
      player = build(:player, dni: "")
      player.valid?
      expect(player.errors[:dni]).to include("can't be blank")
    end
    it 'is invalid with less than nine chars' do
      player = build(:player, dni: "12345678")
      player.valid?
      expect(player.errors[:dni]).to include("is the wrong length (should be 9 characters)")
    end
    it 'is invalid with more than nine chars' do
      player = build(:player, dni: "1234567890")
      player.valid?
      expect(player.errors[:dni]).to include("is the wrong length (should be 9 characters)")
    end
    it 'is invalid without letter in last char' do
      player = build(:player, dni: "123456789")
      player.valid?
      expect(player.errors[:dni]).to include("last char has to be a letter")
    end
    it 'has valid format' do
      player = build(:player, dni: "48960950E")
      expect(player).to be_valid
    end
    it 'is invalid with incorrect format' do
      player = build(:player, dni: "48960950A")
      player.valid?
      expect(player.errors[:dni]).to include("is invalid dni")
    end
    it 'is invalid if with duplicates' do
      jose   = create(:player, firstname: "Jose", dni: "48960950E")
      player = build(:player, firstname: "Manolete", dni: "48960950E")
      player.valid?
      expect(player.errors[:dni]).to include("has already been taken")
    end
  end

  context 'email' do
    it 'has valid format' do
      player = build(:player, email: 'joselito@gmail.com')
      expect(player).to be_valid
    end
    it 'is invalid without correct format' do
      player = build(:player, email: 'joselito@gmailcom')
      player.valid?
      expect(player.errors[:email]).to include("is invalid")
    end
    it 'is invalid with duplicates' do
      jose   = create(:player, firstname: 'jose', email: 'joselito@gmail.com')
      player = build(:player, firstname: 'manolete', email: 'joselito@gmail.com')
      player.valid?
      expect(player.errors[:email]).to include("has already been taken")
    end
  end

  context 'phone' do
    it 'is invalid with less than nine numbers' do
      player = build(:player, phone: "65432178")
      player.valid?
      expect(player.errors[:phone]).to include("is the wrong length (should be 9 characters)")
    end
    it 'is invalid with more than nine numbers' do
      player = build(:player, phone: "1234567890")
      player.valid?
      expect(player.errors[:phone]).to include("is the wrong length (should be 9 characters)")
    end
    it 'is valid with nine numbers' do
      player = build(:player, phone: "987654321")
      expect(player).to be_valid
    end
  end

  describe 'Associations' do
    it 'has and belongs to many events' do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
    it 'has many loans' do
      association = described_class.reflect_on_association(:loans)
      expect(association.macro).to eq :has_many
    end
    it 'has many participants' do
      association = described_class.reflect_on_association(:participants)
      expect(association.macro).to eq :has_many
    end
  end
end
