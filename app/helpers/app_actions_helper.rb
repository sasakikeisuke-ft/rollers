module AppActionsHelper
  # app_action#new/edit

  # アクション新規登録画面における、アクションタイプの選択肢を作成するメソッド
  def make_selects(app_controller)
    # 基本の７つのアクション
    seven_actions = %w[index new create edit update destroy show]
    # 共通する内容を登録するプライベートアクション
    common_actions = %w[get_common_variable1 get_common_variable2 get_common_variable3]
    selects = []
    targets = []
    array = {}
    seven_actions.each do |action|
      selects << [action.to_s, action.to_s] if app_controller["#{action}_select".to_sym] >= 2
    end
    common_actions.each do |action|
      selects << [action.to_s, action.to_s]
    end

    # フォーム専用のメソッドが作成されるされる対象とメソッド名
    app_controller.app_actions.each do |app_action|
      next unless app_action.action_code_id <= 8

      targets << app_action.target unless targets.include?(app_action.target)
      array[app_action.target.to_s.to_sym] = [] if array[app_action.target.to_s.to_sym].nil?
      unless array[app_action.target.to_s.to_sym].include?(app_action.action_select)
        array[app_action.target.to_s.to_sym] << app_action.action_select
      end
    end
    targets.each do |target|
      selects << ["#{target}_form_variable", "#{target}_form_variable"] if array[target.to_s.to_sym].length >= 2
    end

    selects
  end

  # app_action#index / _controller.html.erb

  # コントローラーのコード表示機能に関する内容
  ##  計画: contentsにハッシュ構造を持たせ、引数として使用することで複数のメソッドに渡って受け渡すことができるようにする。
  ### contentsのハッシュ一覧とその内容について
  ### contents[:各アクション名] -> app_actionを対象とするアクションごとに分配し格納する。ここから各アクション内のコードを作成する。
  ### contents[:params_targets] -> ストロングパラメーターを取得する必要のあるモデル名(string)を格納する。ここからmodel_paramsを作成する。
  ### contents[:form_targets] -> フォームの対象となるモデル名(string)を格納する。ここからmodel_form_variableを作成する
  ### contents[:モデル名_form_actions] -> model_form_variableを使用するアクションを格納する。ここからbefore_actionを作成する。
  ### contents[:model_form_variable] -> model_form_variableに実際に記載するインスタンス変数取得に関するコードを格納する。

  # コントローラーに登録されたアクションを配列に分配するメソッド
  def make_controller_array(app_actions)
    # contentsに必要なキーとそれに対応する空白の配列を作成する。
    contents = {}
    actions = %w[index new create edit update destroy show params_targets form_targets]
    actions.each do |action|
      contents[action.to_sym] = []
    end

    # コントローラーに登録されているアクションを配列に分配する。
    app_actions.each do |app_action|
      if app_action.action_code_id <= 96
        contents[app_action.action_select.to_s.to_sym] = [] if contents[app_action.action_select.to_s.to_sym].nil?

        contents[app_action.action_select.to_s.to_sym] << app_action

        # ストロングパラメーターを必要とするアクションから、対象となるモデル名を格納する
        if [2, 3, 4, 5, 6, 7, 8].include?(app_action.action_code_id) && !contents[:params_targets].include?(app_action.target)
          contents[:params_targets] << app_action.target
        end
        # formに関連するモデル名(string)と、model_form_variableを使用するアクションをそれぞれ格納する
        if app_action.action_code_id <= 8
          contents[:form_targets] << app_action.target unless contents[:form_targets].include?(app_action.target)

          contents["#{app_action.target}_form_actions".to_sym] = [] if contents["#{app_action.target}_form_actions".to_sym].nil?
          if app_action.action_code_id == 1 && !contents["#{app_action.target}_form_actions".to_sym].include?(app_action.action_select)
            contents["#{app_action.target}_form_actions".to_sym] << app_action.action_select
          end
          if app_action.action_select == 'update' && !contents["#{app_action.target}_form_actions".to_sym].include?('edit')
            contents["#{app_action.target}_form_actions".to_sym] << 'edit'
          end
        end
      else # app_action.action_code_id >= 97 -> get_common_variableを使用するアクション
        sample = app_action.action_code.sample
        contents["#{sample}_targets".to_sym] = [] if contents["#{sample}_targets".to_sym].nil?
        contents["#{sample}_targets".to_sym] << app_action
      end
    end
    contents
  end

  # 基本の７つのアクションを対象に、登録内容に基づきコードを作成するメソッド。特殊なレイアウトのものにも対応している。
  def make_action_code_remake(app_action, links, content)
    case app_action.action_code_id
    when 5, 6, 7, 8 # 特殊なレイアウトを使用する場合
      create_action_template(app_action, content)
      content[:main] += "#{insert_space(6)}#{app_action.action_code.sample}" if links

      case app_action.action_code_id
      when 5, 6 # createのレイアウトの場合
        content[:first] += "#{insert_space(4)}@#{app_action.target} = "
        content[:first] += "#{app_action.target.classify}.new(#{app_action.target}_params)<br>"
      else # 7, 8 updateのレイアウトの場合
        content[:before] = content[:before].gsub(/save/, "update(#{app_action.target}_params)")
      end

      case app_action.action_code_id
      when 7
        content[:after] = content[:after].gsub(/:new/, ':edit')
      when 6, 8
        content[:before] = content[:before].gsub(/root_path/, input1.to_s) unless app_action.input1 == ''
        content[:after] = content[:after].gsub(/:new/, input2.to_s) unless app_action.input2 == ''
      end
    else # 特殊なレイアウトを使用しない場合
      code = insert_space(4)
      code += app_action.action_code.sample
      code = code.gsub(/models/, app_action.target.tableize.to_s)
      code = code.gsub(/model/, app_action.target.to_s)
      code = code.gsub(/Model/, app_action.target.classify.to_s)
      code = code.gsub(/条件式1/, app_action.input1.to_s) unless app_action.input1 == ''
      code = code.gsub(/条件式2/, app_action.input2.to_s) unless app_action.input2 == ''
      code = code.gsub(/条件式3/, app_action.input3.to_s) unless app_action.input3 == ''
      content[:main] = code
    end
  end

  # createに使用するレイアウトでHTMLを作成するメソッド
  def create_action_template(app_action, content)
    content[:before] += "#{insert_space(4)}if @#{app_action.target}.save<br>"
    content[:before] += "#{insert_space(6)}redirect_to root_path<br>"
    content[:before] += "#{insert_space(4)}else<br>"
    content[:after] +=  "#{insert_space(6)}render :new<br>"
    content[:after] +=  "#{insert_space(4)}end<br>"
  end

  # contents[:params_targets]をもとにストロングパラメーター取得メソッドを作成するメソッド
  def make_strong_parameter(contents)
    models = Model.includes(:columns).where(application_id: params[:application_id])
    target_model = '' # 初期化
    devise_name = '' # 初期化
    html = '' # 初期化
    contents[:params_targets].each do |target|
      models.each do |model|
        target_model = model if model.name == target
        devise_name = model.name if model.model_type_id == 5
      end

      # データ型によって配列を振り分ける。
      activehash_columns = [] # ActiveHashを使用している場合
      references_columns = [] # references型の場合
      normarl_columns = [] # 上記以外のデータ型の場合
      target_model.columns.each do |column|
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
      html += "#{insert_space(2)}def #{target_model.name}_params<br>"
      html += "#{insert_space(4)}params.require(:#{target_model.name}).permit("
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
      if references_columns.length != 0
        first = true
        html += ').merge('
        references_columns.each do |column|
          html += ', ' unless first
          html += if column != devise_name
                    "#{column}_id: params[:#{column}_id]"
                  else
                    "#{column}_id: current_user.id"
                  end
          first = false
        end
      end
      html += ")<br>#{insert_space(2)}end<br><br>"
    end
    html
  end

  # formで使用するインスタンス変数を取得するメソッドである、model_form_variableを作成するメソッド
  def make_model_form_variable(target, app_controllers, contents, links)
    app_controllers.each do |app_controller|
      next unless app_controller.name == target

      parent = app_controller.parent
      next if parent == ''

      contents[:model_form_variable] += "#{insert_space(4)}@#{parent} = #{parent.classify}.find(params[:#{parent}_id])"
      contents[:model_form_variable] += ' <- 自動生成' if links
      contents[:model_form_variable] += '<br>'
      make_model_form_variable(parent, app_controllers, contents, links)
    end
  end

  # before_action: model_form_variableを作成するメソッド
  def make_before_action_model_form_variable(contents)
    html = ''
    contents[:form_targets].each do |target|
      next unless contents["#{target}_form_actions".to_sym].length >= 2

      html += "#{insert_space(2)}before_action :#{target}_form_variable, only: ["
      first = true
      contents["#{target}_form_actions".to_sym].each do |element|
        html += ', ' unless first
        html += ":#{element}"
        first = false
      end
      html += ']<br>'
    end
    html
  end

  # before_action: get_comon_variableを作成するメソッド
  def make_before_action_get_common_variable(contents)
    html = ''
    common_actions = %w[get_common_variable1 get_common_variable2 get_common_variable3]
    common_actions.each do |action|
      next if contents[action.to_sym].nil?

      html += "#{insert_space(2)}before_action :#{action}"
      unless contents["#{action}_targets".to_sym].nil?
        first = true
        html += ', only: ['
        contents["#{action}_targets".to_sym].each do |target|
          html += ', ' unless first
          html += ":#{target.action_select}"
          first = false
        end
        html += ']'
      end
      html += '<br>'
    end
    html
  end

  # before_action: authenticate_user!のHTMLを作成するメソッド
  def before_action_authenticate_user(app_controller)
    html = "#{insert_space(2)}before_action :authenticate_user!"
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
      html += '<br>'
    when 0
      html = ''
    else
      html += action_html + ']<br>'
    end
    html
  end
end
