class Controller < ApplicationRecord
  with_options presence: true do
    validates :name, uniqueness: { case_sensitive: false, scope: :application_id, message: "はすでに存在します" }
    with_options format: { with: /\A[0-9]+\z/, message: 'は半角数字を入力してください' },
                           numericality: { other_than: 0, message: "を選択してください" } do
      validates :index_select
      validates :new_select
      validates :create_select
      validates :edit_select
      validates :update_select
      validates :destroy_select
      validates :show_select
    end
  end

  belongs_to :application
  has_many :actions
end
