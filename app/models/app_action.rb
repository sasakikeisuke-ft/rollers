class AppAction < ApplicationRecord
  validates :target, presence: true
  with_options numericality: { other_than: 0, message: " can't be blank" } do
    validates :action_type_id
    validates :code_type_id
  end

  belongs_to :app_controller

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :action_type
  belongs_to :code_type
end
