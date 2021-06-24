class Application < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_one :gemfile, dependent: :destroy
  has_many :models, dependent: :destroy
end
