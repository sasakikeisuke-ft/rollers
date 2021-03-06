module GemfilesHelper
  # 対象モデルの中で最も長いカラム名の文字数を返すメソッド
  def the_longest(model)
    longest = if model.model_type_id != 5
                6
              else
                18
              end
    model.columns.each do |column|
      long = column.name.length if column.data_type_id != 13
      long = column.name.length + 3 if column.data_type_id == 13
      longest = long if long > longest
    end
    longest
  end

  # 指定した回数だけ - を挿入するメソッド
  def insert_bar(roops)
    bar = ''
    roops.times do
      bar += '-'
    end
    raw(bar)
  end

  # README専用のhasに関するアソシエーションを作成するメソッド
  def readme_association(model, models, columns)
    result = ''
    columns.each do |column|
      next unless column.name == model.name

      models.each do |target_model|
        next unless target_model.id == column.model_id

        result += if target_model.not_only
                    "- has_many :#{target_model.name.pluralize}<br>"
                  else
                    "- has_one :#{target_model.name}<br>"
                  end
        next unless target_model.model_type.name == '中間テーブル'

        target_model.columns.each do |target_column|
          next if target_column.name == model.name

          result += "- has_many :#{target_column.name.pluralize}"
          result += ", through: :#{target_model.name.pluralize}<br>"
        end
      end
    end
    result
  end

  # 日本語化ファイルのHTMLを作成するメソッド
  def make_japanise_html(models)
    result = ''
    models.each do |model|
      next if model.model_type.name == 'Formオブジェクト'

      name_ja_exist = false
      html = "#{insert_space(6)}#{model.name}:<br>"
      model.columns.each do |column|
        next if column.name_ja == ''

        html += "#{insert_space(8)}#{column.name}: #{column.name_ja}<br>"
        name_ja_exist = true
      end
      html = '' unless name_ja_exist
      result += html
    end
    result
  end

  # ルーティングのHTMLを作成するメソッド
  def make_rooting_html(app_controllers)
    relations = []
    make_rooting_relations(app_controllers, relations, '', 0)
    contents = {
      html: ''
    }
    make_rooting_contents(relations, contents)
    contents[:html]
  end

  # コントローラーの親子関係とアクションの内容をまとめた配列を作成するメソッド
  def make_rooting_relations(app_controllers, relations, parent, deep)
    app_controllers.each do |app_controller|
      next unless app_controller.parent == parent

      content = {
        child: app_controller.name.tableize,
        parent: parent,
        deep: deep + 2,
        index_select: app_controller.index_select,
        new_select: app_controller.new_select,
        create_select: app_controller.create_select,
        edit_select: app_controller.edit_select,
        update_select: app_controller.update_select,
        destroy_select: app_controller.destroy_select,
        show_select: app_controller.show_select
      }
      relations << content
      make_rooting_relations(app_controllers, relations, app_controller.name, deep + 2)
    end
  end

  # 親子関係の配列からルーティングに必要なHTMLを作成するメソッド
  def make_rooting_contents(relations, contents)
    deep = 2
    relations.each do |relation|
      if relation[:deep] > deep
        deep = relation[:deep]
        contents[:html] += ' do'
      elsif relation[:deep] < deep
        while deep - 2 >= relation[:deep]
          deep -= 2
          contents[:html] += "<br>#{insert_space(deep)}end"
        end
      end
      contents[:html] += "<br>#{insert_space(deep)}resources :#{relation[:child]}"
      contents[:html] += make_rooting_only(relation)
    end
    while deep - 2 >= 2
      deep -= 2
      contents[:html] += "<br>#{insert_space(deep)}end"
    end
  end

  # ルーティングのonlyメソッドに関するHTMLを作成するメソッド
  def make_rooting_only(relation)
    action_html = ', only: ['
    first = true
    action_count = 0
    actions = %w[index new create edit update destroy show]
    actions.each do |action|
      next unless relation["#{action}_select".to_sym] >= 2

      action_html += ', ' unless first
      action_html += ":#{action}"
      first = false
      action_count += 1
    end
    if action_count == 7
      action_html = ''
    else
      action_html += ']'
    end
    action_html
  end

  def make_devise_parameter(models)
    models.each do |model|
      next unless model.model_type.name == 'devise'
      break if model.columns.empty?

      first = true
      code = ''
      model.columns.each do |column|
        code += ', ' unless first
        code += ":#{column.name}"
        first = false
      end
      result = "#{insert_space(2)}def configure_permitted_parameters<br>"
      result += "#{insert_space(4)}devise_parameter_sanitizer.permit(:sign_up, keys: ["
      result += "#{code}])<br>#{insert_space(2)}end<br><br>"
      return result
    end
  end
  
end
