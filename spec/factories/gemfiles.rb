FactoryBot.define do
  factory :gemfile do
    devise { Faker::Boolean.boolean }
    pry_rails { Faker::Boolean.boolean }
    image_magick { Faker::Boolean.boolean }
    active_hash { Faker::Boolean.boolean }
    rails_i18n { Faker::Boolean.boolean }
    ransack { Faker::Boolean.boolean }
    rubocop { Faker::Boolean.boolean }
    rspec { Faker::Boolean.boolean }
    payjp { Faker::Boolean.boolean }
    s3 { Faker::Boolean.boolean }
    association :application
  end
end
