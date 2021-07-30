class SetActionDefaultService
  def self.set(app_controller)
    default_action = [
      {action_select: "index", target: app_controller.name, code_type_id: 21, app_controller_id: app_controller.id}
    ]
    app_action = AppAction.new(default_action)
    app_action.create
  end
  # id: nil, action_select: "destroy", target: "app_action", code_type_id: 11, app_controller_id: 15, i
end
