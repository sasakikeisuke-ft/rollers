FactoryBot.define do
  factory :application do
    name { Faker::Lorem.characters(number: 8) }
    description { Faker::Lorem.sentence }
    association :user
  end
end
