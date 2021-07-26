class Action < ApplicationRecord
  validates :target, presence: true
  with_options numericality: { other_than: 0, message: "can't be blank"} do
    validates :action_type
    validates :aciton_code
  end

  with_options format: { with: /\A[a-zA-Z0-9!-/:-@¥[-`{-~]+\z/, message: "は英数字および記号のみで入力してください" } do
    validates :input1
    validates :input2
    validates :input3
  end

  belongs_to :app_controller

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :action_type
  belongs_to :aciton_code
end
