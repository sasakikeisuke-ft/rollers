module AppControllersHelper
  # コントローラーのHTMLを作成するメソッドを起動するメソッド。
  #   ストロングパラメーター取得メソッドのHTMLを作成するメソッド
  #   create/edit/update/showで共通するfindを作成するメソッド

  # コントローラーのHTMLを作成するメソッドを起動するメソッド。
  def make_controller_html(app_controller)
    contents = {}

    contents[:params] = true if app_controller.create_select || app_controller.update

    before_authenticate_html(app_controller, contents)
    before_find_html(app_controller, contents)
    make_params_html(app_controller, contents) if contents[:params]
    make_form_html(app_controller, contents)

    # app_controller.actions.each do |action|
    # end
    contents
  end

  # before_actionにおけるauthenticate_user!のHTMLを作成するメソッド
  def before_authenticate_html(app_controller, contents)
    contents[:authenticate] = "#{insert_space(2)}before_action :authenticate_user!"
    action_html = ', only: ['
    first = true
    action_count = 0
    actions = %w[index new create edit update destroy show]
    actions.each do |action|
      next unless app_controller["#{action}_select".to_sym] >= 3

      action_html += ', ' unless first
      action_html += ":#{action}"
      first = false
      action_count += 1
    end
    case action_count
    when 7
      contents[:authenticate] += '<br>'
    when 0
      contents[:authenticate] = ''
    else
      action_html += ']<br>'
      contents[:authenticate] += action_html
    end
  end

  # ストロングパラメーター取得メソッドに関するHTMLを作成するメソッド
  def make_params_html(app_controller, contents)
    models = app_controller.application.models
    model = models.includes(:columns).find_by(name: app_controller.name)
    devise = models.find_by(model_type_id: 5) # devise対応のモデルを取得

    # データ型によって配列を振り分ける。
    references_columns = []
    activehash_columns = []
    normarl_columns = []
    model.columns.each do |column|
      case column.data_type_id
      when 12 # references型のカラム
        references_columns << column.name
      when 13 # ActiveHashを参照するカラム
        activehash_columns << column.name
      else
        normarl_columns << column.name
      end
    end
    # 振り分けられた配列をもとにHTMLを作成
    html = "#{insert_space(2)}def #{app_controller.name}_params<br>"
    html += "#{insert_space(4)}params.require(:#{model.name}).permit("
    first = true
    normarl_columns.each do |column|
      html += ', ' unless first
      html += ":#{column}"
      first = false
    end
    activehash_columns.each do |column|
      html += ', ' unless first
      html += ":#{column}_id"
      first = false
    end
    html += ')'
    if references_columns.length != 0
      first = true
      html += '.merge('
      references_columns.each do |column|
        html += ', ' unless first
        html += if column != devise.name
                  "#{column}_id: params[:#{column}]"
                else
                  "#{column}_id: current_user.id"
                end
        first = false
      end
    end
    html += ")<br>#{insert_space(2)}end<br>"
    contents[:params] = html
  end

  # create/edit/update/showで共通するfind_modelメソッドを作成するメソッド
  def make_find_html(app_controller, contents)
    html = "#{insert_space(2)}def find_#{app_controller.name}<br>"
    html += "#{insert_space(4)}@#{app_controller.name} = #{app_controller.name.classify}.find(params[:id])<br>"
    html += "#{insert_space(2)}end<br>"
    contents[:find_model] = html
  end

  # 上記find_modelメソッドをbefore_actionとして機能するHTMLを作成するメソッド
  def before_find_html(app_controller, contents)
    contents[:before_find] = "#{insert_space(2)}before_action :find_#{app_controller.name}, only: ["
    first = true
    action_count = 0
    actions = %w[edit update destroy show]
    actions.each do |action|
      next unless app_controller["#{action}_select".to_sym] >= 2

      contents[:before_find] += ', ' unless first
      contents[:before_find] += ":#{action}"
      first = false
      action_count += 1
      contents["#{action}_exist".to_sym] = true
    end
    case action_count
    when 0
      contents[:before_find] = ''
    when 1
      contents[:before_find] = ''
      actions.each do |action|
        if contents["#{action}_exist".to_sym]
          contents["action_#{action}".to_sym] =
            "#{insert_space(4)}@#{app_controller.name} = #{app_controller.name.classify}.find(params[:id])<br>"
        end
      end
    else
      contents[:before_find] += ']<br>'
      make_find_html(app_controller, contents)
    end
  end

  # フォームの部分テンプレートに必要なインスタンス変数を取得するメソッド
  def make_form_html(app_controller, contents)
    parents = app_controller.application.app_controllers
    relations = []
    make_form_relations(app_controller, parents, relations)
    unless relations.length == 0
      contents[:form] = "#{insert_space(2)}def instance_variable_for_form<br>"
      make_form_code(relations, contents)
      contents[:form] += "#{insert_space(2)}end<br>"
      contents[:action_new] = "#{insert_space(4)}instance_variable_for_form<br>"
      contents[:action_edit] = "#{insert_space(4)}instance_variable_for_form<br>"
    end
  end

  def make_form_relations(app_controller, parents, relations)
    unless app_controller.parent == ''
      parents.each do |parent|
        next unless parent.name == app_controller.parent

        content = {
          child: app_controller.name,
          parent: parent.name
        }
        relations << content
        make_form_relations(parent, parents, relations)
      end
    end
  end

  def make_form_code(relations, contents)
    relations.each do |relation|
      contents[:form] += "#{insert_space(4)}@#{relation[:parent]} = @#{relation[:child]}.#{relation[:parent]}<br>"
    end
  end
end
