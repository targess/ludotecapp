FactoryGirl.define do
  factory :organization do
    name { Faker::StarWars.character }
  end
end
