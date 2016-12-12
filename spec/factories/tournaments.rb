FactoryGirl.define do
  factory :tournament do
    name              { Faker::StarWars.specie }
    max_participants  20
    max_competitors   16
    date              { Faker::Date.between(2.days.ago, 10.days.from_now) }
    minage            8
    boardgame         { FactoryGirl.create(:boardgame) }
    event             { FactoryGirl.create(:event) }
  end
end
