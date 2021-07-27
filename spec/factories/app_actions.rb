FactoryBot.define do
  factory :app_action do
    action_type_id { Faker::Number.non_zero_digit }
    target { Faker::Lorem.characters(number: 8) }
    code_type_id { Faker::Number.non_zero_digit }
    input1 { Faker::Lorem.characters(number: 8) }
    input2 { Faker::Lorem.characters(number: 8) }
    input3 { Faker::Lorem.characters(number: 8) }
    association :app_controller
  end
end
