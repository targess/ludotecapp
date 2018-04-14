FactoryGirl.define do
  factory :event do
    name        { Faker::StarWars.planet }
    start_date  10.days.ago
    end_date    10.days.from_now
    city        { Faker::Address.city }
    province    { Faker::Address.state }
    association :organization

    factory :invalid_event do
      name nil
    end
  end
end
