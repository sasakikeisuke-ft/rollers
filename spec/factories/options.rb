FactoryBot.define do
  factory :option do
    option_type_id { Faker::Number.non_zero_digit }
    input1 { Faker::Lorem.characters(number: 8) }
    input2 { Faker::Lorem.characters(number: 8) }
    association :column
  end
end
