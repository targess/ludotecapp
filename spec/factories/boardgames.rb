FactoryGirl.define do
  factory :boardgame do
    name         "Carcassonne"
    description  "a tiles and meeples collocation boardgame"
    minplayers   2
    maxplayers   Faker::Number.between(from = 2, to = 5)

    factory :invalid_boardgame do
      name nil
    end
  end
end
