require 'rails_helper'

RSpec.describe Designer do
  it 'is valid with name' do
    designer = build(:designer, name: 'Devir')
    expect(designer).to be_valid
  end

  it 'is invalid without a name' do
    designer = build(:designer, name: nil)
    designer.valid?
    expect(designer.errors[:name]).to include("can't be blank")
  end

  it 'cant have duplicate bgg_id' do
    create(:designer, bgg_id: 1)
    designer = build(:designer, bgg_id: 1)
    designer.valid?
    expect(designer.errors[:bgg_id]).to include('has already been taken')
  end

  context 'find or build from hash' do
    context 'with valid hash' do
      it 'and existing DB designer, returns matching designer' do
        designer = create(:designer, bgg_id: 1)
        designer_hash = designer.attributes
        expect(Designer.from_hash(designer_hash)).to eq(designer)
      end
      it 'and new, build thats new one' do
        designer_hash = {bgg_id: 1, name: 'Devir' }
        expect(Designer.from_hash(designer_hash)).to be_a_kind_of(Designer)
      end
    end

    context 'without valid hash' do
      it 'and empty, returns nil' do
        expect(Designer.from_hash({})).to be(nil)
      end
      it 'and invalid format, returns nil'
    end
  end

  context 'has Associations' do
    it 'HABTM with Boardgames' do
      association = Designer.reflect_on_association(:boardgames)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
  end
end
