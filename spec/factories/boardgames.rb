FactoryGirl.define do
  factory :boardgame do
    name         "Carcassonne"
    description  "a tiles and meeples collocation boardgame"
    minplayers   2
    maxplayers   Faker::Number.between(2, 5)
    barcode      "1234567890123"
    internalcode "12345"

    factory :invalid_boardgame do
      name nil
    end
  end
end
