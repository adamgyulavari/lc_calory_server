FactoryGirl.define do
  factory :user do
    email    { Faker::Internet.email }
    password { Devise.friendly_token[0, 20] }
    goal     { (0..200).to_a.sample }

    factory :user_with_entries do
      after(:create) do |user|
        (0..5).each do
          create :entry, user_id: user.id
        end
      end
    end
  end
end
