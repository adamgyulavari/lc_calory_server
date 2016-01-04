FactoryGirl.define do
  factory :entry do
    user_id    1
    title      { Faker::Lorem.word }
    num        { (0..50).to_a.sample }
    entry_date { Faker::Date.between(2.days.ago, Date.today) }
    entry_time { (0..24).to_a.sample * 60 + (0..60).to_a.sample }
  end
end
