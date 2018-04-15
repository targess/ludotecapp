require "rails_helper"

RSpec.describe Publisher do
  it 'is valid with name' do
    publisher = build(:publisher, name: 'Devir')
    expect(publisher).to be_valid
  end

  it 'is invalid without a name' do
    publisher = build(:publisher, name: nil)
    publisher.valid?
    expect(publisher.errors[:name]).to include("can't be blank")
  end

  it 'cant have duplicate bgg_id' do
    create(:publisher, bgg_id: 1)
    publisher = build(:publisher, bgg_id: 1)
    publisher.valid?
    expect(publisher.errors[:bgg_id]).to include('has already been taken')
  end

  context 'find or build from hash' do
    context 'with valid hash' do
      it 'and existing DB publisher, returns matching publisher' do
        publisher = create(:publisher, bgg_id: 1)
        publisher_hash = publisher.attributes
        expect(Publisher.from_hash(publisher_hash)).to eq(publisher)
      end
      it 'and new, build thats new one' do
        publisher_hash = {bgg_id: 1, name: 'Devir' }
        expect(Publisher.from_hash(publisher_hash)).to be_a_kind_of(Publisher)
      end
    end

    context 'without valid hash' do
      it 'and empty, returns nil' do
        expect(Publisher.from_hash({})).to be(nil)
      end
      it 'and invalid format, returns nil'
    end
  end

  context ' has Associations' do
    it 'HABTM with Boardgames' do
      association = Publisher.reflect_on_association(:boardgames)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
  end
end
