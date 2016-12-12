FactoryGirl.define do
  factory :participant do
    confirmed false
    waiting_list false
    player nil
    tournament nil
  end
end
