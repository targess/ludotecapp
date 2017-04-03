FactoryGirl.define do
  factory :player do
    dni         { Faker::DNI.dni }
    firstname   { Faker::Name.first_name }
    lastname    { Faker::Name.last_name }
    city        { Faker::Address.city }
    province    { Faker::Address.state }
    birthday    { Faker::Date.birthday(18, 65) }
    email       { Faker::Internet.email }
    phone       { Faker::Number.between(600_000_000, 699_999_999) }

    factory :player_with_organizations do
      transient do
        organizations_count 1
      end

      before(:create) do |player, evaluator|
        create_list(:organization, evaluator.organizations_count, players: [player])
      end
    end

    factory :invalid_player do
      dni nil
    end
  end
end
