class ProcessAtModelNameChangeService
  # モデル名変更時に他のテーブルの登録内容に変更を行うサービス。モデル名が変更された時のみ処理を行う。
  ## remove: モデル名変更に伴いユーザーが関与できなくなってしまったレコードを削除する。
  ## 実装した機能には採用していないがrenameメソッドで困難な場合もあるため残しておく。
  def self.remove(before_name, after_name, application_id)
    return if before_name == after_name

    # app_actionにおけるmodel_form_variableを取得し削除する。
    app_actions = AppAction.where(application_id: application_id, action_select: "#{before_name}_form_variable")
    app_actions.destroy_all
  end

  ## rename: モデル名変更に伴い、string型のモデル名を登録しているデータを新名称へ変更する。
  ## 最低限必要なapp_actionsテーブルのモデル名変更を反映するメソッド。
  def self.rename(before_name, after_name, application_id)
    return if before_name == after_name

    # app_actionでmodel名が含まれるレコードを取得し、更新後の名称へ変更する。
    app_actions_action_selects = AppAction.where(application_id: application_id, action_select: "#{before_name}_form_variable")
    app_actions_action_selects.update(action_select: "#{after_name}_form_variable")
    app_actions_targets = AppAction.where(application_id: application_id, target: before_name)
    app_actions_targets.update(target: after_name)
  end

  ## rename_all: 上記はapp_actionsテーブルのみの変更だが、このメソッドでは他の全てのテーブルの名称を自動変更する。
  ## 動作や処理、データベースへの負担が非常に重くなる可能性あり。動作に注意すること。
  def self.rename_all(before_name, after_name, application_id)
    return if before_name == after_name

    # app_actionでmodel名が含まれるレコードを全て取得し、更新後の名称へ変更する。処理が非常に重くなる可能性がある。
    columns = Column.where(application_id: application_id, name: before_name)
    columns.update(name: after_name)
    app_controllers = AppController.where(application_id: application_id, name: before_name)
    app_controllers.update(name: after_name)
    app_actions_action_selects = AppAction.where(application_id: application_id, action_select: "#{before_name}_form_variable")
    app_actions_action_selects.update(action_select: "#{after_name}_form_variable")
    app_actions_targets = AppAction.where(application_id: application_id, target: before_name)
    app_actions_targets.update(target: after_name)
  end
end
