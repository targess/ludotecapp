FactoryGirl.define do
  factory :participant do
    confirmed    false
    substitute   false
    player       { FactoryGirl.create(:player) }
    tournament   { FactoryGirl.create(:tournament) }

    factory :substitute do
      waiting_list true
    end
    factory :competitor do
      confirmed true
    end
  end
end
