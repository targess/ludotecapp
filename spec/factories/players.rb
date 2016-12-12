FactoryGirl.define do
  factory :player do
    dni         { Faker::DNI.dni }
    firstname   { Faker::Name.first_name }
    lastname    { Faker::Name.last_name}
    city        { Faker::Address.city }
    province    { Faker::Address.state }
    birthday    { Faker::Date.birthday(min_age = 18, max_age = 65) }
    email       { Faker::Internet.email }
    phone       { Faker::Number.between(from = 600000000, to = 699999999) }

    factory :invalid_player do
        dni nil
    end
  end
end
