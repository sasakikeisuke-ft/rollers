class SetDefaultActionService
  # コントローラー登録時に初期設定となるアクション＝デフォルトアクションを登録するメソッド。
  def self.set(app_controller)
    target_model = Model.where(application_id: app_controller.application_id).find_by(name: app_controller.name)
    puts target_model.name
    puts app_controller.name
    return unless target_model.name == app_controller.name

    # app_controllerの登録内容により、初期設定とするアクションの情報を配列に格納する。
    default_actions = []
    find_actions = []
    base = { target: app_controller.name, app_controller_id: app_controller.id, application_id: app_controller.application_id }
    default_actions << base.merge(action_select: 'new', action_code_id: 1) if app_controller.new_select >= 2
    default_actions << base.merge(action_select: 'create', action_code_id: 5) if app_controller.create_select >= 2
    find_actions << 'edit' if app_controller.edit_select >= 2
    if app_controller.update_select
      default_actions << base.merge(action_select: 'update', action_code_id: 7)
      find_actions << 'update'
    end
    if app_controller.destroy_select
      default_actions << base.merge(action_select: 'destroy', action_code_id: 9)
      default_actions << base.merge(action_select: 'destroy', action_code_id: 91)
      find_actions << 'destroy'
    end
    find_actions << 'show' if app_controller.edit_select >= 2

    # common_variableが必要かどうかで処理を変更する。
    if find_actions.length >= 2
      find_actions.each do |action|
        default_actions << base.merge(action_select: action, action_code_id: 97)
      end
      default_actions << base.merge(action_select: 'common_variable1', action_code_id: 11)
    elsif find_actions.length == 1
      default_actions << base.merge(action_select: find_actions[0], action_code_id: 11)
    end

    # 上記で作成したdefault_actionsをもとに、初期設定となるapp_actionを登録する。
    default_actions.each do |default_action|
      AppAction.create(default_action)
    end
  end
end
