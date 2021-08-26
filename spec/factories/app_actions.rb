FactoryBot.define do
  factory :app_action do
    action_select { Faker::Lorem.characters(number: 8) }
    target { Faker::Lorem.characters(number: 8) }
    action_code_id { Faker::Number.non_zero_digit }
    input1 { Faker::Lorem.characters(number: 8) }
    input2 { Faker::Lorem.characters(number: 8) }
    input3 { Faker::Lorem.characters(number: 8) }
    association :app_controller
    association :application
  end
end
