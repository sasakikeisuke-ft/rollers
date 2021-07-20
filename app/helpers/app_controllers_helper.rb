module AppControllersHelper

  # コントローラーのコードを作成するメインのメソッド。ここから複数のメソッドを起動する。
  def make_controller_html(app_controller)
    contents = {}



    make_params_html(app_controller, contents)
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
    html = "#{insert_space(2)}find_#{insert_space(2)}def #{app_controller.name}<br>"
    html += "#{insert_space(4)}@#{app_controller.name} = #{app_controller.name.classify}.find(params[:id])<br>"
    html += "#{insert_space(2)}end<br><br>"
    contents[:find_model] = html
  end

end
