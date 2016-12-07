FactoryGirl.define do
  factory :loan do
    created_at   { Faker::Time.between(2.days.ago, 2.days.ago, :morning) }
    returned_at  { Faker::Date.between(2.days.ago, 2.days.ago, :afternoon) }
    player       { FactoryGirl.create(:player) }
    boardgame    { FactoryGirl.create(:boardgame) }
    event        { FactoryGirl.create(:event) }


    factory :not_returned_loan do
      returned_at nil
    end
  end
end
