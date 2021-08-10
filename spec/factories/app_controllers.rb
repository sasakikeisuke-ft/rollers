FactoryBot.define do
  factory :app_controller do
    name { Faker::Lorem.characters(number: 8) }
    parent { Faker::Lorem.characters(number: 8) }
    target { Faker::Lorem.characters(number: 8) }
    index_select { Faker::Number.non_zero_digit }
    new_select { Faker::Number.non_zero_digit }
    create_select { Faker::Number.non_zero_digit }
    edit_select { Faker::Number.non_zero_digit }
    update_select { Faker::Number.non_zero_digit }
    destroy_select { Faker::Number.non_zero_digit }
    show_select { Faker::Number.non_zero_digit }
    association :application
  end
end
