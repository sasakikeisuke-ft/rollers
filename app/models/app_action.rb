class AppAction < ApplicationRecord
  with_options presence: true do
    validates :target
    validates :action_select
  end
  
  validates :code_type_id, numericality: { other_than: 0, message: " can't be blank" }

  belongs_to :app_controller

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :code_type
end
