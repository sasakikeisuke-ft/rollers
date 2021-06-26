class Column < ApplicationRecord
  validates :name, presence: true
  validates :data_type_id, numericality: { other_than: 0, message: "を選択してください" }

  belongs_to :model
  has_many :options, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :data_type

end
