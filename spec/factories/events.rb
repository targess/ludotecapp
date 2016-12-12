FactoryGirl.define do
  factory :event do
    name        { Faker::StarWars.planet }
    start_date  { Faker::Date.between(2.days.ago, 10.days.from_now) }
    end_date    { Faker::Date.between(10.days.from_now, 20.days.from_now) }
    city        { Faker::Address.city }
    province    { Faker::Address.state }

    factory :invalid_event do
      name nil
    end
  end
end
