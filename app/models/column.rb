class Column < ApplicationRecord
  with_options presence: true do
    validates :data_type_id, numericality: { other_than: 0, message: 'を選択してください' }
    validates :name, uniqueness: { case_sensitive: false, scope: :model_id }
  end
  with_options inclusion: { in: [true, false] } do
    validates :must_exist
    validates :unique
  end
  belongs_to :application
  belongs_to :model
  has_many :options, dependent: :destroy

  # ActiveHash
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :data_type
end
