class Model < ApplicationRecord
  validates :name, presence: true
  validates :model_type_id, numericality: { other_than: 0, message: "を選択してください" }

  belongs_to :application
  has_many :columns, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :model_type

end
