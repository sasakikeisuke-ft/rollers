class Association < ApplicationRecord
  with_options presence: true do
    validates :left
    validates :right
  end

  belongs_to :application

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :relation

end
