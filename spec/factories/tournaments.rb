FactoryGirl.define do
  factory :tournament do
    name "MyString"
    max_participants 1
    max_competitors 1
    date "2016-12-12 16:01:05"
    minage 1
    boardgame nil
    event nil
  end
end
