class Column < ApplicationRecord
  validates :name,presence: true
  validates :data_option_id, numericality: { other_than: 0, message: "を選択してください" }

  belongs_to :model

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :data_option

end
