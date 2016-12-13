FactoryGirl.define do
  factory :tournament do
    name              { Faker::StarWars.specie }
    max_competitors   16
    max_substitutes   8
    date              "11/01/2016"
    minage            8
    boardgame         { FactoryGirl.create(:boardgame) }
    event             { FactoryGirl.create(:event) }
  end
end
