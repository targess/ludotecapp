FactoryGirl.define do
  factory :tournament do
    name              { Faker::StarWars.specie }
    max_competitors   16
    max_substitutes   8
    date              1.day.from_now
    minage            8
    boardgame         { FactoryGirl.create(:boardgame) }
    event             { FactoryGirl.create(:event) }
  end
end
