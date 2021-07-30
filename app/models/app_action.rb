class AppAction < ApplicationRecord
  with_options presence: true do
    validates :target
    validates :action_select
  end
  
  validates :code_type_id, numericality: { other_than: 0, message: " can't be blank" }

  belongs_to :app_controller

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :code_type

  # コントローラー登録時にアクションのデフォルト設定を登録するメソッド。サービスクラスに切り出すべき。
  def self.set(app_controller)
    default_action = {action_select: "index", target: app_controller.name, code_type_id: 21, app_controller_id: app_controller.id}
    
    app_action = AppAction.create(default_action)
  end
  # id: nil, action_select: "destroy", target: "app_action", code_type_id: 11, app_controller_id: 15, 

end
