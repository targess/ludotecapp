require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'is valid with name, start and end date' do
    event = build(:event, name: 'Mi evento', start_date: '10/1/2016', end_date: '12/1/2016')
    expect(event).to be_valid
  end
  it 'is invalid without name' do
    event = build(:event, name: nil)
    event.valid?
    expect(event.errors[:name]).to include ("can't be blank")
  end
  it 'is invalid without start date' do
    event = build(:event, start_date: nil)
    event.valid?
    expect(event.errors[:start_date]).to include ("can't be blank")
  end
  it 'is invalid without end date' do
    event = build(:event, end_date: nil)
    event.valid?
    expect(event.errors[:end_date]).to include ("can't be blank")
  end
  it 'is valid with start date before end date' do
    event = build(:event, start_date: '10/1/2016', end_date: '12/1/2016')
    expect(event).to be_valid
  end
  it 'is valid with start date equal to end date' do
    event = build(:event, start_date: '10/1/2016', end_date: '10/1/2016')
    expect(event).to be_valid
  end
  it 'is invalid with start date after end date' do
    event = build(:event, start_date: '20/1/2016', end_date: '10/1/2016')
    event.valid?
    expect(event.errors[:start_date]).to include ("can't be after end_date")
  end
end
