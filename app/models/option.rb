class Option < ApplicationRecord
  validates :option_type_id, presence: true, numericality: { other_than: 0, message: "を選択してください" }
  belongs_to :column

  # ActiveHash
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :option_type
end
