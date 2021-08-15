module TestsHelper

  # マイグレーションファイルに追記する項目に関する記述を作成するメソッド
  def make_migration_appending(model)
    result = ''
    model.columns.each do |column|
      result += insert_space(6)
      case column.data_type.type
      when 'references'
        result += "t.#{column.data_type.type} :#{column.name}, foreign_key: true"
      when 'ActiveHash'
        result += "t.integer :#{column.name}_id, null: false"
      else
        result += "t.#{column.data_type.type} :#{column.name}"
        result += ', null: false' if column.must_exist
        result += ', unique: true' if column.unique
      end
      result += '<br>'  
    end
    result
  end

  ##  計画: contentsにハッシュ構造を持たせ、引数として使用することで複数のメソッドに渡って受け渡すことができるようにする。
  ### contentsのハッシュ一覧とその内容について
  ### contents[:presence_true] -> 空欄禁止として登録したカラムを格納する。バリデーションの作成に必要。
  ### contents[:presence_false] -> 空欄禁止として登録せず、optionの登録がされているカラムを格納する。上記と別の処理を行う。
  ### contents[:boolean_group] -> 上記とは別にboolean型のカラムを格納する。バリデーションの処理が異なるため別の配列に格納する。
  ### contents[:references_group] -> references型のカラムを格納する。この配列を参考にアソシエーションに関する記載を行う。
  ### contents[:activehash_group] -> activehash型のカラムを格納する。データ型をintegerに固定し、また専用のアソシエーションを記載する。
  ### contents[japanese] -> gemfileにて、日本語化ファイルを適応するかどうかの情報を格納する。

  # 配列を作成するメソッド
  def make_model_array(model, gemfile)
    contents = make_model_array_template
    contents[:japanese] = gemfile.rails_i18n
    
    if model.model_type.name != 'Formオブジェクト'
      target_columns = model.columns
    else  # Formオブジェクトの場合、特別な処理により、対象としているモデルのカラムが全てを取得する
      target_columns = make_form_object(model, contents)
    end

    # 取得したカラムを配列へと振り分けていく。
    target_columns.each do |column|
      if column.data_type_id <= 10
        contents[:presence_true] << column if column.must_exist
        contents[:presence_false] << column if !column.must_exist && column.options.length != 0
      else
        case column.data_type.type
        when 'boolean'
          contents[:boolean_group] << column
        when 'references'
          contents[:references_group] << column
          # valid_references_group << content if content[:options] != ''
        when 'ActiveHash'
          contents[:activehash_group] << column
        end
      end
    end
    contents[:presence_true] += contents[:references_group] if model.model_type.name == 'ActiveHash'
    contents[:presence_true] += contents[:activehash_group]
    contents
  end

  # contentsのハッシュに紐づけられた空の配列を作成するメソッド。make_model_arrayの事前準備として使用する。
  def make_model_array_template
    categorcies = %W[
      presence_true presence_false
      boolean_group references_group activehash_group
      normal_group abnormal_group
    ]
    contents = {}
    categorcies.each do |category|
      contents[category.to_sym] = []
    end
    contents
  end

  # モデルファイルのバリデーションに関する記載を作成するメソッド
  def make_varidation(contents, japanese)
    html = ''
    space = 2
    after = "#{insert_space(space)}end<br>"

    # 空欄禁止を設定されたものから処理を行う。
    option = 'presence: true'
    html += use_with_option?(contents[:presence_true], space, japanese, option)

    # 空欄を禁止せずoptionのみ設定されたgroupの処理を行う。
    html += make_with_options(contents[:presence_false], space, japanese)

    # boolean型のグループに関するvaridationを記載する。
    option = 'inclusion:{in: [true, false]}'
    html += use_with_option?(contents[:boolean_group], space, japanese, option)
    
    # 最終的なHTMLを返却する
    html
  end

  # with_optionを使用するかどうかを判断し、必要に応じてメソッドを使用するメソッド
  def use_with_option?(group, space, japanese, option)
    html = ''
    if group.length >= 2
      html += "#{insert_space(space)}with_options #{option} do<br>"
      html += make_with_options(group, space + 2, japanese)
      html += "#{insert_space(space)}end<br>"
    elsif group.length == 1
      html += "#{insert_space(space)}varidates :#{group[0].name}, #{option}"
      group[0].options.each do |option|
        html += make_options(option, japanese)
      end
      html += '<br>'
    end
    html
  end 


  # optionに関する記載を行うメソッド。そのカラムのオプションのみ追加していく。
  def make_options(option, japanese)
    code = option.option_type.code
    code = code.gsub(/入力1/, option.input1) unless option.input1 == ''
    code = code.gsub(/入力2/, option.input2) unless option.input2 == ''
    if japanese
      code = code.gsub(/エラーメッセージ/, option.option_type.message_ja)
    else
      code = code.gsub(/エラーメッセージ/, option.option_type.message_en)
    end
    code = ", #{code}"
    code
  end

  def make_with_options(group, space, japanese)
    result = ''
    content = {
      else: [],
      single: []
    }
    grouping_ids = [11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 25]
    # 引数となるcontents[:presence_true]とcontents[:presence_false]をグループ化できるoptionごとに再分配。
    # ただし、通常と異なる登録方法を行うActiveHashについては、option_type_id: 25として扱う。
    group.each do |column|
      if column.data_type.type != 'ActiveHash'
        added = false
        column.options.each do |option|
          next unless grouping_ids.include?(option.option_type_id)
  
          id = option.option_type_id
          content["option_type_#{id}".to_sym] = [] if content["option_type_#{id}".to_sym].nil?
          content["option_type_#{id}".to_sym] << column
          added = true
        end
        content[:else] << column unless added  
      else  # column.data_type.type != 'ActiveHash'
        content[:option_type_25] = [] if content[:option_type_25].nil?
        content[:option_type_25] << column
      end
    end

    # 分配した配列をもとにバリデーションを作成する。
    grouping_ids.each do |id|
      next if content["option_type_#{id}".to_sym].nil?
      
      if content["option_type_#{id}".to_sym].length >= 2
        option_type = OptionType.find(id)
        if japanese
          code = option_type.code.gsub(/エラーメッセージ/, option_type.message_ja)
        else
          code = option_type.code.gsub(/エラーメッセージ/, option_type.message_en)
        end
        before = "#{insert_space(space)}with_options #{code} do<br>"
        after = "#{insert_space(space)}end<br>"
        during = ''
        content["option_type_#{id}".to_sym].each do |column|
          name = column.name
          name = "#{column.name}_id" if column.data_type.type = 'ActiveHash'
          during += "#{insert_space(space + 2)}varidates :#{name}"
          column.options.each do |option|
            next if grouping_ids.include?(option.option_type_id)

            during += make_options(option, japanese)
          end
          during += '<br>'
        end
        result += before + during + after
      else  # if content["option_type_#{id}".to_sym].length == 1
        content[:single] += content["option_type_#{id}".to_sym]
      end
    end

    # formatを使用していないカラムのバリデーションを記載する。
    content[:single] += content[:else]
    content[:single].each do |column|
      result += "#{insert_space(space)}varidates :#{column.name}"
      column.options.each do |option|
        result += make_options(option, japanese)
      end
      result += '<br>'
    end
    result
  end

  # アソシエーションに関する記述を作成するメソッド
  def make_association(contents, columns, model, attached_image)
    html = ''
    space = 2
    
    # belongs_toに関する記述を作成する。
    contents[:references_group].each do |column|
      html += "#{insert_space(2)}belongs_to :#{column.name}<br>"
    end

    # has_many/has_oneに関する記述を作成する。ここでのcolumnsはアプリに関連する全てのカラムが対象となっている。
    columns.each do |column|
      # このモデル名と同じカラム名である -> references型で対象がこのモデル -> 対象モデルではbelongs_toが記載されている。
      next unless column.name == model.name

      if model.not_only
        has ='has_many :'
      else
        has = 'has_one :'
      end
      target_model = column.model
      html += "#{insert_space(space)}#{has}#{target_model.name.tableize}<br>"

      # target_modelが中間テーブルの場合、追加処理を行う。
      next unless target_model.model_type_id == 3

      target_columns = target_model.columns.where.not(name: model.name)
      target_columns.each do |target_column|
        html += "#{insert_space(space)}has_many :#{target_column.name}"
        html += ", through: :#{target_model.name}<br>"
      end
    end

    # ImageMagickを使用する場合のアソシエーションを記載
    html += "#{insert_space(2)}has_one_attached :image<br>" if attached_image

    # ActiveHashに関する記述を作成するメソッド。
    if contents[:activehash_group].length != 0
      html += "<br>#{insert_space(2)}# ActiveHash<br>"
      html += "#{insert_space(2)}extend ActiveHash::Associations::ActiveRecordExtensions<br>"
      contents[:activehash_group].each do |column|
        html += "#{insert_space(2)}belongs_to :#{column.name}<br>"
      end
    end
    html
  end

  # Formオブジェクトパターンに必要な処理を行うメソッド。追加するハッシュは以下
  ## contents[:attr_accessor] -> attr_accessorに必要な記述をまとめて格納する。
  ## contents[:save] -> Formオブジェクトに必要なsaveメソッドに関する記述を格納する。
  def make_form_object(model, contents)
    # Formオブジェクトに必要なカラムを全て取得する。
    target_model_names = []
    model.columns.each do |column|
      target_model_names << column.name
    end
    target_models = Model.where(name: target_model_names)
    target_columns = Column.where(model_id: target_models).includes(:options)

    # 各記述を行う事前準備。二つの記述にコードを追加していく。
    contents[:attr_accessor] = "#{insert_space(2)}attr_accessor "
    contents[:save] = "<br>#{insert_space(2)}def save<br>"
    accessor_first = true

    # モデルごとに処理を行う。
    target_models.each do |target_model|
      contents[:save] += "#{insert_space(4)}#{target_model.name} = #{target_model.name.classify}.create("
      save_first = true
      target_columns.each do |column|
        next unless column.model_id == target_model.id
        
        # contents[:attr_accessor]
        contents[:attr_accessor] += ', ' unless accessor_first
        contents[:attr_accessor] += column.name
        accessor_first = false

        # contents[:save]
        contents[:save] += ', ' unless save_first
        if target_model_names.include?(column.name)
          contents[:save] += "#{column.name}_id: #{column.name}.id"
        elsif ['references', 'ActiveHash'].include?(column.data_type.type)
          contents[:save] += "#{column.name}_id: #{column.name}_id"
        else
          contents[:save] += "#{column.name}: #{column.name}"
        end
        save_first = false
      end
      contents[:save] += ')<br>'
    end
    contents[:attr_accessor] += '<br><br>'
    contents[:save] += "#{insert_space(2)}end<br>"
    target_columns
  end

end  #/ module
