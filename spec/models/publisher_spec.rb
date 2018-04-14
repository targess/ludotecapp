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

  context ' has Associations' do
    it 'HABTM with Boardgames' do
      association = Publisher.reflect_on_association(:boardgames)
      expect(association.macro).to eq :has_and_belongs_to_many
    end
  end
end
