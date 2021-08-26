FactoryBot.define do
  factory :model do
    name { Faker::Lorem.characters(number: 8) }
    not_only { Faker::Boolean.boolean }
    attached_image { Faker::Boolean.boolean }
    model_type_id { Faker::Number.non_zero_digit }
    association :application
  end
end
