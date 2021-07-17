class Model < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :application_id }
  validates :model_type_id, numericality: { other_than: 0, message: 'を選択してください' }

  with_options inclusion: { in: [true, false] } do
    validates :not_only
    validates :attached_image
  end

  belongs_to :application
  has_many :columns, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :model_type
end
