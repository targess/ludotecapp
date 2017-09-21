FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    association :organization

    factory :admin do
      admin true
    end
  end
end
