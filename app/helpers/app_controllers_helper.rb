module AppControllersHelper

  # コントローラーのコードを作成するメインのメソッド。ここから複数のメソッドを起動する。
  def make_controller_html(app_controller)
    contents = {
      before_find_count: 0,
      before_common_count: 0
    }

    # app_controller.actions.each do |action|

    if app_controller.create_select || app_controller.update
      contents[:params] = true
    end

    make_params_html(app_controller, contents) if contents[:params]
    make_find_html(app_controller, contents)
    contents
  end




  def make_params_html(app_controller, contents)
    target = app_controller.application.models.includes(:columns).find_by(name: app_controller.name)
    references_array = []
    activehash_array = []
    normarl_array = []
    target.columns.each do |column|
      case column.data_type_id
      when 12
        references_array << column.name
      when 13
        activehash_array << column.name
      else
        normarl_array << column.name
      end
    end
    html = "#{insert_space(2)}def #{app_controller.name}_params<br>"
    html += "#{insert_space(4)}params.require(:#{target.name}).permit("
    first = true
    normarl_array.each do |element|
      html += ', ' unless first
      html += ":#{element}"
      first = false
    end
    activehash_array.each do |element|
      html += ', ' unless first
      html += ":#{element}_id"
      first = false
    end
    html += ')'
    first = true
    if references_array.length != 0
      html += '.merge('
      references_array.each do |element|
        html += ', ' unless first
        html += "#{element}: params[:#{element}]"
        first = false
      end
    end
    html += ")<br>#{insert_space(2)}end<br><br>"
    contents[:params] = html
  end

  def make_find_html(app_controller, contents)
    parents = @app_controller.application.app_controllers
    array = []
    make_find_array(app_controller, parents, array)
    
    html = "#{insert_space(2)}def find_#{app_controller.name}<br>"
    html += "#{insert_space(4)}@#{app_controller.name} = #{app_controller.name.classify}.find(params[:id])<br>"
    array.each do |element|
      html += "#{insert_space(4)}@#{element[:parent]} = @#{element[:child]}.#{element[:parent]}<br>"
    end
    html += "#{insert_space(2)}end<br><br>"
    contents[:find_model] = html
  end

  def make_find_array(app_controller, parents, array)
    unless app_controller.parent == ''
      parents.each do |parent|
        if parent.name == app_controller.parent
          content = {
            child: app_controller.name,
            parent: parent.name
          }
          array << content
          make_find_array(parent, parents, array)
        end
      end
    end
  end

  # 失敗作。スコープの問題だと思うが原因がわかっていない。後学のため残してく。
  def add_find_html(app_controller, parents, html)
    if app_controller.parent != ''
      parents.each do |parent|
        if parent.name == app_controller.parent
          html += "#{insert_space(4)}@#{parent.name} = @#{app_controller.name}.#{parent.name}<br>"
         add_find_html(parent, parents, html) 
        end
      end
    end
  end

end
