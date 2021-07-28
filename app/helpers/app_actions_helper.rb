module AppActionsHelper
  def actions_index(app_actions)
    contents = make_actions_template
    
    app_actions.each do |app_action|
      code = make_action_code(app_action, contents)
      contents[app_action.action_select.to_sym] << code
    end

    actions = %w[index new create edit update destroy show]
    actions.each do |action|
      contents[action.to_sym] = sort_sentence(contents[action.to_sym], 0)
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

  def make_action_code(app_action, contents)
    code = app_action.code_type.sample
    code = code.gsub(/models/, "#{app_action.target.tableize}")
    code = code.gsub(/model/, "#{app_action.target}")
    code = code.gsub(/Model/, "#{app_action.target.classify}")
    code = code.gsub(/条件式1/, "#{app_action.input1}") unless app_action.input1 == ''
    code = code.gsub(/条件式2/, "#{app_action.input2}") unless app_action.input1 == ''
    code = code.gsub(/条件式3/, "#{app_action.input3}") unless app_action.input1 == ''
    code = code += '<br>'
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
