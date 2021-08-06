module AppActionsHelper

  # アクション新規登録画面における、アクションタイプの選択肢を作成するメソッド
  def make_selects(app_controller)
    actions = %w[index new create edit update destroy show]
    selects = []
    find_count = 0
    form_count = 0
    actions.each do |action|
      if app_controller["#{action}_select".to_sym] >= 2
        select = ["#{action}", "#{action}"]
        selects << select

        case action
        when 'create' 
          form_count += 1
        when 'edit', 'update'
          find_count += 1
          form_count += 1
        when 'destroy'
          find_count += 1
        when 'show'
          find_count += 1
        end
      end
    end
    selects << ['find_model', 'find_model'] if find_count >= 2
    selects << ['instance_variable_for_form', 'instance_variable_for_form'] if form_count >= 2

    selects 
  end


  # app_actions.each文の中で、登録アクションに関するHTMLを作成するメソッド。レイアウトを使う場合は別処理を行う。
  def make_action_code_remake(app_action, links, content)
    case app_action.action_code_id
    when 5, 6, 7, 8 # レイアウトを使用する場合
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
        content[:after] = content[:after].gsub(/:new/, ":edit")
      when 6, 8
        content[:before] = content[:before].gsub(/root_path/, "#{input1}") unless app_action.input1 == ''
        content[:after] = content[:after].gsub(/:new/, "#{input2}") unless app_action.input2 == ''
      end
    else
      code = insert_space(4)
      code += app_action.action_code.sample
      code = code.gsub(/models/, "#{app_action.target.tableize}")
      code = code.gsub(/model/, "#{app_action.target}")
      code = code.gsub(/Model/, "#{app_action.target.classify}")
      code = code.gsub(/条件式1/, "#{app_action.input1}") unless app_action.input1 == ''
      code = code.gsub(/条件式2/, "#{app_action.input2}") unless app_action.input2 == ''
      code = code.gsub(/条件式3/, "#{app_action.input3}") unless app_action.input3 == ''
      content[:main] = code
    end
  end

  # ストロングパラメーターに関するHTMLを作成するメソッド
  ## app_controller_helperの既存メソッドを引用し編集中。引数を登録actionで作成する形を検討
  ## linksにより編集/削除へのリンクを表示するか切り替えられるように実装したい。
  def make_strong_parameter(app_action, contents, links)
    # next unless app_action.action_code_id == ?

    # modelモデルが関連する箇所がここだけなので、メソッド内で動作
    models = Model.where(application_id: params[application_id])
    model = models.includes(:columns).find_by(name: app_action.target)
    devise = models.find_by(model_type_id: 5) # devise対応のモデルを取得

    # データ型によって配列を振り分ける。
    normarl_columns = []
    activehash_columns = []
    references_columns = []
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
    html = "#{insert_space(2)}def #{app_action.target}_params<br>"
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
    if references_columns.length != 0
      first = true
      html += ').merge('
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




  # 上記のストロングパラメーターを自動で作成するメソッド
  ## createとupdateがある場合は必要となるため、引数から決定する必要はないのではないか？。
  ## 対象のモデルを選出する必要がある。targetsを作る専用のメソッドと併用する可能性を考慮しつつ、まずは単体で完結するメソッドを考える。
  def make_strong_parameter_proto1(app_actions)
    # ストロングパラメーターが必要なアクションからターゲットとなるモデル名を選出する。
    params_targets = []
    app_actions.each do |app_action|
      if %w[2 3 4 5 6 7 8].include?(app_action.action_code_id) 
        params_targets << app_action.target unless params_targets.include?(app_action.target)
      end
    end

    # 選出したモデルからストロングパラメーター取得メソッドを作成する。今のところは上記メソッドを引用する。
    params_targets.each do |target|
      models = Model.where(application_id: params[application_id])
      model = models.includes(:columns).find_by(name: app_action.target)
      devise = models.find_by(model_type_id: 5) # devise対応のモデルを取得

      # データ型によって配列を振り分ける。
      normarl_columns = []
      activehash_columns = []
      references_columns = []
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
      html = "#{insert_space(2)}def #{app_action.target}_params<br>"
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
      if references_columns.length != 0
        first = true
        html += ').merge('
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
      html += ")<br>#{insert_space(2)}end<br><br>"
      contents[:params] = html 
    end
  end

  # 登録されているアクションから必要となるプライベートメソッドを作成するメソッド。
  # 配列を作成した後に、各プライベートメソッドを作成するメソッドを呼び出す。
  def make_contents_of_controller(app_actions)
    contents = {before: ''}
    params_targets = []
    
    app_actions.each do |app_action|
      if [2, 3, 4, 5, 6, 7, 8].include?(app_action.action_code_id) 
        params_targets << app_action.target unless params_targets.include?(app_action.target)
      end
    end

    make_strong_parameter_proto2(params_targets, contents)

    contents
  end

  def make_strong_parameter_proto2(params_targets, contents)
    models = Model.where(application_id: params[:application_id])
    devise = models.find_by(model_type_id: 5) # devise対応のモデルを取得

    params_targets.each do |target|
      model = models.includes(:columns).find_by(name: target)

      # データ型によって配列を振り分ける。
      normarl_columns = []
      activehash_columns = []
      references_columns = []
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
      html = "#{insert_space(2)}def #{model.name}_params<br>"
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
      if references_columns.length != 0
        first = true
        html += ').merge('
        references_columns.each do |column|
          html += ', ' unless first
          html += if column != devise.name
                    "#{column}_id: params[:#{column}_id]"
                  else
                    "#{column}_id: current_user.id"
                  end
          first = false
        end
      end
      html += ")<br>#{insert_space(2)}end<br><br>"
      contents[:params] = html 
    end
  end













  # 新しいプランの範囲----------------------------------------------------


  # 新しいプラン。contentsにハッシュ構造を持たせ、引数として使用することで複数のメソッドに渡って受け渡すことができるようにする。
  ## contents[:各アクション名] -> app_actionを対象とするアクションごとに分配し格納する。ここから各アクション内のコードを作成する。
  ## contents[:params_targets] -> ストロングパラメーターを取得する必要のあるモデル名(string)を格納する。ここからmodel_paramsを作成する。
  ## contents[:form_targets] -> フォームの対象となるモデル名(string)を格納する。ここからmodel_form_variableを作成する
  ## contents[:モデル名_form_actions] -> model_form_variableを使用するアクションを格納する。ここからbefore_actionを作成する。

  # コントローラーに登録されたアクションを配列に分配するメソッド
  def make_controller_array(app_actions)
    contents = { actions: %w[
      index new create edit update destroy show
      get_common_before1 get_common_before2 get_common_before3
      params_targets form_targets
    ]}
    contents[:actions].each do |action|
      contents[action.to_sym] = []
    end

    app_actions.each do |app_action|
      if contents["#{app_action.action_select}".to_sym].nil?
        contents["#{app_action.action_select}".to_sym] = []
      end

      contents["#{app_action.action_select}".to_sym] << app_action

      # ストロングパラメーターを必要とするアクションから、対象となるモデル名を格納する
      if [2, 3, 4, 5, 6, 7, 8].include?(app_action.action_code_id) 
        contents[:params_targets] << app_action.target unless contents[:params_targets].include?(app_action.target)
      end
      # formに関連するモデル名(string)と、model_form_variableを使用するアクションをそれぞれ格納する
      if app_action.action_code_id <= 8
        contents[:form_targets] << app_action.target unless contents[:form_targets].include?(app_action.target)
        if contents["#{app_action.target}_form_actions".to_sym].nil?
          contents["#{app_action.target}_form_actions".to_sym] = []
        end
        unless contents["#{app_action.target}_form_actions".to_sym].include?(app_action.action_select)
          contents["#{app_action.target}_form_actions".to_sym] << 'edit' if app_action.action_select == 'update'
          contents["#{app_action.target}_form_actions".to_sym] << app_action.action_select if app_action.action_code_id == 1
        end
      end
      

    end
    # contentsの内容確認
    puts '---------------'
    puts "対象モデル：#{contents[:form_targets]} -> optionなら成功"
    puts "対象アクション: #{contents[:option_form_actions]}"
    puts '---------------'
    
    contents
  end

  # contents[:params_targets]をもとにストロングパラメーター取得メソッドを作成するメソッド
  def make_strong_parameter_proto3(contents)
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
      normarl_columns = []
      activehash_columns = []
      references_columns = []
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
  def make_model_form_variable(target, app_controllers, contents)
    app_controllers.each do |app_controller|
      if app_controller.name == target
        parent = app_controller.parent
        next if parent == ''

        contents[:model_form_variable] += "#{insert_space(4)}@#{parent} = #{parent.classify}.find(params[:#{parent}_id])<br>"
        make_model_form_variable(parent, app_controllers, contents)
      end  
    end
  end

  def make_before_action_model_form_variable(contents)
    html = ''
    contents[:form_targets].each do |target|
      next unless contents["#{target}_form_actions".to_sym].length >= 2

      html += "#{insert_space(2)}before_action :#{target}_form_variable, only: ["
      first = true
      contents["#{target}_form_actions".to_sym].each do |element|
        html += ', ' unless first
        html += ":#{element.to_s}"
        first = false
      end
      html += ']<br>'
    end
    html
  end

  #/////////// 新しいプランの範囲----------------------------------------------------











  # createに使用するレイアウトでHTMLを作成するメソッド
  def create_action_template(app_action, content)
    content[:before] += "#{insert_space(4)}if @#{app_action.target}.save<br>"
    content[:before] += "#{insert_space(6)}redirect_to root_path<br>"
    content[:before] += "#{insert_space(4)}else<br>"
    content[:after] +=  "#{insert_space(6)}render :new<br>"
    content[:after] +=  "#{insert_space(4)}end<br>"
  end


  def actions_index(app_controller, app_actions)
    contents = make_actions_template
    actions = %w[index new create edit update destroy show]
    actions.each do |action|
      next unless app_controller["#{action}_select".to_sym] >= 2

      contents[action.to_sym] = make_action_code(app_actions, action)
      html = "#{insert_space(2)}def #{action}<br>"
      if action == 'create' || action == 'update'
        html += "#{insert_space(4)}if @#{app_controller.name}.save<br>"
        html += "#{insert_space(6)}redirect_to root_path<br>"
        html += "#{insert_space(4)}else<br>"
        html += "#{insert_space(6)}instance_variable_for_form<br>"
      else
        html += contents[action.to_sym]
      end
      case action
      when 'create'
        html += "#{insert_space(6)}render :new"
        html += "#{insert_space(4)}end<br>"
      when 'update'
        html += "#{insert_space(6)}render :edit"
        html += "#{insert_space(4)}end<br>"
      end
      html += "#{insert_space(2)}end<br><br>"
      contents[action.to_sym] = html
    end
    contents
  end

  def make_actions_template
    contents = {
      index: [],
      new: [],
      create: [],
      edit: [],
      update: [],
      destroy: [],
      show: []
    }
    contents
  end


  # 登録内容からsampleコードを編集し、アクションのコードを作成するメソッド
  def make_action_code(app_actions, action)
    code = ''
    app_actions.each do |app_action|
      next unless app_action.action_select == action

      space = 4
      code = insert_space(space)
      code += app_action.action_code.sample
      code = code.gsub(/models/, "#{app_action.target.tableize}")
      code = code.gsub(/model/, "#{app_action.target}")
      code = code.gsub(/Model/, "#{app_action.target.classify}")
      code = code.gsub(/条件式1/, "#{app_action.input1}") unless app_action.input1 == ''
      code = code.gsub(/条件式2/, "#{app_action.input2}") unless app_action.input2 == ''
      code = code.gsub(/条件式3/, "#{app_action.input3}") unless app_action.input3 == ''
      code += '<br>'
    end
    code
  end


  def make_action_code_single(app_action, action)
    space = 4
    code = insert_space(space)
    code += app_action.action_code.sample
    code = code.gsub(/models/, "#{app_action.target.tableize}")
    code = code.gsub(/model/, "#{app_action.target}")
    code = code.gsub(/Model/, "#{app_action.target.classify}")
    code = code.gsub(/条件式1/, "#{app_action.input1}") unless app_action.input1 == ''
    code = code.gsub(/条件式2/, "#{app_action.input2}") unless app_action.input2 == ''
    code = code.gsub(/条件式3/, "#{app_action.input3}") unless app_action.input3 == ''
    code
  end




  def sort_sentence(sentence_array, space)
    html = ''
    sentence_array.each do |sentence|
      html += insert_space(space)
      html += sentence
    end
    html
  end

end