class Application < ApplicationRecord

  validates :application_name, presence: true

  belongs_to :user
  has_one :gemfile
end
