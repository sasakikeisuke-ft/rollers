FactoryBot.define do
  factory :column do
    name { Faker::Lorem.characters(number: 8) }
    name_ja { Faker::Lorem.characters(number: 8) }
    data_type_id { Faker::Number.non_zero_digit }
    must_exist { Faker::Boolean.boolean }
    unique { Faker::Boolean.boolean }
    association :model
    association :application
  end
end
