class Column < ApplicationRecord
  validates :name, presence: true
  validates :data_type_id, numericality: { other_than: 0, message: "を選択してください" }
    
  with_options inclusion: { in: [true, false] } do
    validates :must_exist
    validates :unique
  end

  belongs_to :application
  belongs_to :model
  has_many :options, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :data_type

end
