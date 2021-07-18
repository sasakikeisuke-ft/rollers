class Controller < ApplicationRecord
  with_options presence: true do
    validates :nameuniqueness: { scope: :application_id, message: "はすでに存在します" }
    with_options format: { with: /\A[0-9]+\z/, message: 'は半角数字を入力してください' },
                           numericality: { other_than: 0, message: "を選択してください" } do
      validates :index
      validates :new
      validates :create
      validates :edit
      validates :update
      validates :destroy
      validates :show
    end
  end

  belongs_to :application
  has_many :actions
end
