class SetDefaultActionService
  # コントローラー登録時に初期設定となるアクション＝デフォルトアクションを登録するメソッド。
  def self.set(app_controller)
    target_model = Model.where(application_id: app_controller.application_id).find_by(name: app_controller.name)
    puts target_model.name
    puts app_controller.name
    if target_model.name == app_controller.name
      # app_controllerの登録内容により、初期設定とするアクションの情報を配列に格納する。
      default_actions = []
      find_actions = []
      if app_controller.new_select >= 2
        default_actions << {action_select: 'new', target: app_controller.name, action_code_id: 1, app_controller_id: app_controller.id}
      end
      if app_controller.create_select >= 2
        default_actions << {action_select: 'create', target: app_controller.name, action_code_id: 5, app_controller_id: app_controller.id}
      end
      if app_controller.edit_select >= 2
        find_actions << 'edit'
      end
      if app_controller.update_select
        default_actions << {action_select: 'update', target: app_controller.name, action_code_id: 7, app_controller_id: app_controller.id}
        find_actions << 'update'
      end
      if app_controller.destroy_select
        default_actions << {action_select: 'destroy', target: app_controller.name, action_code_id: 9, app_controller_id: app_controller.id}
        default_actions << {action_select: 'destroy', target: app_controller.name, action_code_id: 91, app_controller_id: app_controller.id}
        find_actions << 'destroy'
      end
      if app_controller.edit_select >= 2
        find_actions << 'show'
      end

      # get_common_variableが必要かどうかで処理を変更する。
      if find_actions.length >= 2
        find_actions.each do |action|
          default_actions << {action_select: action, target: app_controller.name, action_code_id: 97, app_controller_id: app_controller.id}
        end
        default_actions << {action_select: 'get_common_variable1', target: app_controller.name, action_code_id: 11, app_controller_id: app_controller.id}
      elsif find_actions.length == 1
        default_actions << {action_select: find_actions[0], target: app_controller.name, action_code_id: 11, app_controller_id: app_controller.id}
      end

      # 上記で作成したdefault_actionsをもとに、初期設定となるapp_actionを登録する。
      default_actions.each do |default_action|
        AppAction.create(default_action)
      end
    end
  end
end
