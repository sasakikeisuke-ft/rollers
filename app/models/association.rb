class Association < ApplicationRecord
  with_options presence: true do
    validates :left
    validates :right
  end

  validates :relation_id, numericality: { other_than: 0, message: "を選択してください" }


  belongs_to :application

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :relation

end
