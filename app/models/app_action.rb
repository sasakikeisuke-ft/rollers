class AppAction < ApplicationRecord
  with_options presence: true do
    validates :target
    validates :action_select
  end
  
  validates :action_code_id, numericality: { other_than: 0, message: " can't be blank" }

  belongs_to :app_controller

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :action_code

  # コントローラー登録時にアクションのデフォルト設定を登録するメソッド。サービスクラスに切り出すべきか
  def self.set(app_controller)
    default_actions = []
    if app_controller.new_select
      default_actions << {action_select: 'new', target: app_controller.name, action_code_id: 1, app_controller_id: app_controller.id}
    end
    if app_controller.create_select
      default_actions << {action_select: 'create', target: app_controller.name, action_code_id: 5, app_controller_id: app_controller.id}
    end
    if app_controller.update_select
      default_actions << {action_select: 'update', target: app_controller.name, action_code_id: 7, app_controller_id: app_controller.id}
    end
    if app_controller.destroy_select
      default_actions << {action_select: 'destroy', target: app_controller.name, action_code_id: 9, app_controller_id: app_controller.id}
      default_actions << {action_select: 'destroy', target: app_controller.name, action_code_id: 91, app_controller_id: app_controller.id}
    end
    default_actions.each do |default_action|
      AppAction.create(default_action)
    end
  end

end
