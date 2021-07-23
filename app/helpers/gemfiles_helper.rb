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

  # 日本語化ファイルのHTMLを作成するメソッド
  def make_japanise_html(models)
    html = ''
    models.each do |model|
      html += "#{insert_space(6)}#{model.name}:"
      html += '<br>'
      model.columns.each do |column|
        html += if column.name_ja != ''
                  "#{insert_space(8)}#{column.name}: #{column.name_ja}"
                else
                  "#{insert_space(8)}#{column.name}: #{column.name}"
                end
        html += '<br>'
      end
    end
    html
  end

  # ルーティングのHTMLを作成するメソッド
  def make_rooting_html(app_controllers)
    relations = []
    make_rooting_relations(app_controllers, relations, '', 0)
    puts relations
    contents = {
      html: ''
    }
    make_rooting_contents(relations, contents)
    contents[:html]
  end

  # コントローラーの親子関係とアクションの内容をまとめた配列を作成するメソッド
  def make_rooting_relations(app_controllers, relations, parent, deep)
    app_controllers.each do |app_controller|
      if app_controller.parent == parent
        content = {
          child: app_controller.name,
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
  end

  # 親子関係の配列からルーティングに必要なHTMLを作成するメソッド
  def make_rooting_contents(relations, contents)
    deep = 2
    relations.each do |relation|
      if relation[:deep] > deep
        deep = relation[:deep]
        contents[:html] += " do"
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
    if relation[:index_select] >= 2
      action_html += ', ' unless first
      action_html += ':index'
      first = false
      action_count += 1
    end
    if relation[:new_select] >= 2
      action_html += ', ' unless first
      action_html += ':new'
      first = false
      action_count += 1
    end
    if relation[:create_select] >= 2
      action_html += ', ' unless first
      action_html += ':create'
      first = false
      action_count += 1
    end
    if relation[:edit_select] >= 2
      action_html += ', ' unless first
      action_html += ':edit'
      first = false
      action_count += 1
    end
    if relation[:update_select] >= 2
      action_html += ', ' unless first
      action_html += ':update'
      first = false
      action_count += 1
    end
    if relation[:destroy_select] >= 2
      action_html += ', ' unless first
      action_html += ':destroy'
      first = false
      action_count += 1
    end
    if relation[:show_select] >= 2
      action_html += ', ' unless first
      action_html += ':show'
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

end
