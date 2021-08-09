class Application < ApplicationRecord
  validates :name, presence: true

  belongs_to :user
  has_one :gemfile, dependent: :destroy
  has_many :models, dependent: :destroy
  has_many :columns, dependent: :destroy
  has_many :app_controllers, dependent: :destroy
  has_many :app_actions, dependent: :destroy  
end
