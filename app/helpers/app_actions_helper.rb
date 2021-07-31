module AppActionsHelper
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

  # createに使用するレイアウトでHTMLを作成するメソッド
  def create_action_template(app_action, content)
    content[:before] += "#{insert_space(4)}if @#{app_action.target}.save<br>"
    content[:before] += "#{insert_space(6)}redirect_to root_path<br>"
    content[:before] += "#{insert_space(4)}else<br>"
    content[:after] +=  "#{insert_space(6)}render :new<br>"
    content[:after] +=  "#{insert_space(4)}end<br>"
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
    selects << ['find_model', 'find_mode'] if find_count >= 2
    selects << ['instance_variable_for_form', 'instance_variable_for_form'] if form_count >= 2

    selects 
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