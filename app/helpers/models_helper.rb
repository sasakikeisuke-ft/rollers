module ModelsHelper

  def make_contents_html(model, gemfile)
    
    migration_html = ''
    validation_html = ''
    presence_true = []
    presence_false = []
    boolean_group = []
    belong_group = []
    activehash_group = []

    # 取得したカラムごとに文章を作成していきます。eachメソッドは一回で済むようにします。
    model.columns.each do |column|

      # マイグレーションファイルのモデルごとの記載を作成します。
      migration_html += make_migration_html(column)

      # データ型とmust_existによって、追加先の配列を選択します。
      #optionの表記が必要なグループを、さらにpresence: trueが必要かで追加先の配列を決めます
      if column.data_type_id <= 10
        options_html = make_options_html(column, gemfile.rails_i18n)
        content = {
          name: column.name,
          options: options_html
        }
        presence_true << content if column.must_exist
        presence_false << content if !column.must_exist && content[:options] != ''
      # 処理内容を別にしたいカラムは、それぞれ専用の配列へ追加します。
      else
        content = { name: column.name }
        boolean_group << content if column.data_type_id == 11
        belong_group << content if column.data_type_id == 12
        activehash_group << content if column.data_type_id == 13
      end
    end
    #/ ここまでで配列が完成しました。

    # ここから実際のHTMLをmake_validation_htmlメソッドを使用し作成します
    common = 'presence: true'
    validation_html += make_validation_html(presence_true, common)

    common = 'inclusion: { in: [true, false] }'
    validation_html += make_validation_html(boolean_group, common)

    common = `numericality: { other_than: 0, message: "can't be blank" }`
    validation_html += make_validation_html(activehash_group, common)

    common = ''
    validation_html += make_validation_html(presence_false, common)

    # アソシエーションのbelongs_toに関する記載を行います。
    belongs_to_html = make_belong(belong_group, '', false)
    activehash_html = make_belong(activehash_group, '', true)

    # 作成したHTMLをハッシュにしてビューファイルへ返します
    contents_html = {
      migration_html: migration_html,
      validation_html: validation_html,
      belongs_to_html: belongs_to_html,
      activehash_html: activehash_html
    }
  end

  def make_migration_html(column)
    html = ""
    html += insert_space(6)
    html += "t.#{column.data_type.type} :#{column.name}"
    if column.data_type.type == 'references'
      html += ", foreign_key: true"
    else 
      html += ", null: false" if column.must_exist
      html += ", unique: true" if column.unique
    end
    html += "<br>"
    return html
  end

  def make_options_html(column, japanese)
    html = ""
    column.options.each do |option|
      
      # ActiveHash app/models/option_type.rbのデータを使用します。
      # numericalityについては、一旦は改行なしで記載します。
      if option.option_type_id <= 20 || option.option_type_id >= 41
        html += option.option_type.code

      # オプションがnumericalityの場合は特別処理を行います。
      elsif option.option_type.type == 'numericality'
        html += ',<br>'
        html += insert_space(14)
        html += 'format: { with: /\A[0-9]+\z/, message: '
        if japanese
          html += "'は半角数字を入力してください' },<br>"
        else
          html += "'is invalid. Input harf-width numbers' },<br>"
        end
        html += insert_space(14)
        if [21, 25].include?(option.option_type_id)
          html += option.option_type.code
        elsif option.option_type.info == '上限下限を設定する'
          html += 'numericality: {greater_than_or_equal_to: '
          html += option.input1 if option.input1 != nil
          html += '数値' if option.input1 == nil
          html += ', less_than_or_equal_to: '
          html += option.input2 if option.input2 != nil
          html += '数値' if option.input2 == nil
          html += ', message: '
        elsif option.option_type.info == '上限のみを設定する'
          html += 'numericality: {less_than_or_equal_to: '
          html += option.input1 if option.input1 != nil
          html += '数値' if option.input1 == nil
          html += ', message: '
        elsif option.option_type.info == '上限下限を設定する'
          html += 'numericality: {greater_than_or_equal_to: '
          html += option.input2 if option.input2 != nil
          html += '数値' if option.input2 == nil
          html += ', message: '
        end
      end

      # エラーメッセージを追加します
      if japanese
        html += option.option_type.message_ja
        html += '}'
      else
        html += option.option_type.message_en
        html += '}'
      end
    end
    return html
  end

  def make_validation_html(array, common)
    html = ''
    if array.length  == 0
      return ''
    elsif array.length == 1 || common == ''
      array.each do |element|
        html += insert_space(2)
        html += 'validates :'
        html += element[:name]
        html += element[:options]
        html += '<br>'
      end
    elsif array.length >= 2
      html += insert_space(2)
      html += 'with_options '
      html += common
      html += ' do<br>'
      array.each do |element|
        html += insert_space(4)
        html += 'validates :'
        html += element[:name]
        html += element[:options]
        html += '<br>'
      end
      html += insert_space(2)
      html += 'end<br><br>'
    end
    return html
  end

  # references型カラム名からbelongs_toの対象を定め、HTMLを作成します。
  def make_belong(array, before, activehash)
    return if array.length == 0
    html = ''
    if activehash
      html += insert_space(2)
      html += 'extend ActiveHash::Associations::ActiveRecordExtensions'
      html += '<br>'
    end
    array.each do |element|
      html += insert_space(2) if before == ''
      html += before if before != ''
      html += 'belongs_to :'
      html += element[:name]
      html += '<br>'
    end
    return html
  end

  

  
end