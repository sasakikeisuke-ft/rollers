class Model < ApplicationRecord
  with_options presence: true do
    validates :model_type_id, numericality: { other_than: 0, message: "を選択してください" }
    validates :name, uniqueness: { case_sensitive: false, scope: :application_id }
  end
  with_options inclusion:{ in: [true, false] } do
    validates :not_only
    validates :attached_image
  end
  belongs_to :application
  has_many :columns, dependent: :destroy

  # ActiveHash
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :model_type
end
