class Gemfile < ApplicationRecord
  with_options inclusion:{in: [true, false]} do
    validates :devise
    validates :pry_rails
    validates :image_magick
    validates :active_hash
    validates :rails_i18n
    validates :ransack
    validates :rubocop
    validates :rspec
    validates :payjp
    validates :s3
  end

  belongs_to :application
end
