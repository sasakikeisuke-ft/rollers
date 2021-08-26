class AppAction < ApplicationRecord
  with_options presence: true do
    validates :action_code_id, numericality: { other_than: 0, message: "を選択してください" }
    validates :action_select
    validates :target
  end
  belongs_to :app_controller
  belongs_to :application

  # ActiveHash
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :action_code
end
