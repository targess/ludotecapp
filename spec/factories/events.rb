FactoryGirl.define do
  factory :event do
    name        { Faker::StarWars.planet }
    start_date  "10/01/2016"
    end_date    "12/01/2016"
    city        { Faker::Address.city }
    province    { Faker::Address.state }
    organization { FactoryGirl.create(:organization) }

    factory :invalid_event do
      name nil
    end
  end
end
