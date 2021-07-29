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

  def make_action_code(app_actions, action)
    code = ''
    app_actions.each do |app_action|
      next unless app_action.action_select == action

      space = 4
      code = insert_space(space)
      code += app_action.code_type.sample
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
    code += app_action.code_type.sample
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
