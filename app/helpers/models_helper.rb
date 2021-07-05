module ModelsHelper

  # メインとなるHTML作成メソッド。
  def make_contents_html(model, gemfile)
    
    migration_html = ''
    validation_html = ''
    presence_true = []
    presence_false = []
    boolean_group = []
    belong_group = []
    activehash_group = []
    normal_groups = []
    abnormal_groups = []
      
    # 取得したカラムごとに文章を作成していきます。eachメソッドは一回で済むようにします。
    model.columns.each do |column|

      # マイグレーションファイルのモデルごとの記載を作成します。
      migration_html += make_migration_html(column)

      # データ型とmust_existによって、追加先の配列を選択します。
      content = {name: column.name}
      #optionの表記が必要なグループを、さらにpresence: trueが必要かで追加先の配列を決めます
      if column.data_type_id <= 10
        content[:options] = make_options_html(column, gemfile.rails_i18n)
        presence_true << content if column.must_exist
        presence_false << content if !column.must_exist && content[:options] != ''
      # 処理内容を別にしたいカラムは、それぞれ専用の配列へ追加します。
      else
        boolean_group << content if column.data_type_id == 11
        belong_group << content if column.data_type_id == 12
        activehash_group << content if column.data_type_id == 13
      end

      # RSpecのための配列を作成します
      make_group_exist(model, column, abnormal_groups, normal_groups)
      make_group_options(model, column, abnormal_groups)
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

    # RSpecのexampleに関するHTMLを作成します
    normal_example_html = make_normal_examples_html(normal_groups)
    abnormal_example_html = make_abnormal_example_html(abnormal_groups, gemfile.rails_i18n)
      

    # 作成したHTMLをハッシュにしてビューファイルへ返します
    contents_html = {
      migration_html: migration_html,
      validation_html: validation_html,
      belongs_to_html: belongs_to_html,
      activehash_html: activehash_html,
      normal_example_html: normal_example_html,
      abnormal_example_html: abnormal_example_html
    }
  end

  # マイグレーションに記載する項目のHTMLを作成するメソッド。
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

  # バリデーションにおけるoptionのHTMLを作成するメソッド
  def make_options_html(column, japanese)
    html = ""
    column.options.each do |option|
      
      # ActiveHash app/models/option_type.rbのデータを使用しています。
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
      html += make_message_html(option, japanese)
      html += '}'
    end
    return html
  end

  # エラー文日本語化を設定しているかどうかで、エラー文を選択します。
  def make_message_html(option, japanese)
    if japanese
      html = option.option_type.message_ja
    else
      html = option.option_type.message_en
    end
  end

  # with_optionsが使用できるかどうかで記載形態を変更するメソッド
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

  # references型カラム名からbelongs_toの対象を定め、HTMLを作成するメソッド。
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

  # アソシエーションのhas_many/has_oneを作成するメソッド
  # 中間メソッドの場合に必要な追記も組み込んでいます
  def make_has(columns, model)
    html = ''
    columns.each do |column|
      # 以下の条件が合った場合にのみ処理を行う。
      if column.name == model.name
        html += insert_space(2)
        if model.not_only
          html += 'has_many :' 
        else
          html += 'has_one :'
        end
        target = column.model
        html += target.name
        html += '<br>'
        # 中間テーブルの場合、
        # 動作確認が未実施。今後エラーの可能性があり注意が必要。
        if target.model_type_id == 4 
          target_columns = target.columns.where.not(name: model.name)
          target_columns.each do |tie|
            html += insert_space(2)
            html += 'has_many :'
            html += tie.name
            html += ', through: :'
            html += target.name
          end
        end
      end
    end
    return html
  end


  # 以下はRSpecに関するメソッド

  # FactoryBotのカラムを作成するメソッド

  # FactoryBotのアソシエーションを作成するメソッド


  


  # カラムを受け取ってexampleのための配列を作成するメソッド
  def make_group_exist(model, column, abnormal_groups, normal_groups)
    content = {model: model.name, column: column.name}
    if column.must_exist
      content[:info] = 'が空欄だと登録できない'
      content[:change] = "''"
      content[:message_ja] = 'を入力してください'
      content[:message_en] = "is can't be blank"
      abnormal_groups << content
    else
      normal_groups << content
    end
  end

  # columnのoptionごとにexampleのための配列を作成するメソッド
  def make_group_options(model, column, abnormal_groups)
    column.options.each do |option| 
      case option.option_type.type
      when 'format'
        # 数字が含まれる場合に対するexample
        if [11, 12, 13, 19].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に数字が含まれていると保存できない'
          content[:change] = "'12345678'"
          abnormal_groups << content
        end
          # 英字が含まれる場合に対するexample
        content = group_of_base(model, column, option)
        content[:info] = 'に英字が含まれていると保存できない'
        content[:change] = "'abcdefgh'"
        abnormal_groups << content
        # 漢字が含まれる場合に対するexample
        if [12, 13, 19].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に漢字が含まれていると保存できない'
          content[:change] = "'漢字漢字漢字漢字'"
          abnormal_groups << content
        end
        # ひらがなが含まれる場合に対するexample
        if [13, 19].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'にひらがなが含まれていると保存できない'
          content[:change] = "'ひらがなひらがな'"
          abnormal_groups << content
        end
        # カタカナが含まれる場合に対するexample
        if [12, 19].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'にカタカナが含まれていると保存できない'
          content[:change] = "'カタカナカタカナ'"
          abnormal_groups << content
        end
      end
    end
  end

  # combination_of_optionの重複部分をまとめるメソッド
  def group_of_base(model, column, option)
    content = {
      model: model.name,
      column: column.name,
      message_ja: option.option_type.message_ja,
      message_en: option.option_type.message_en
    }
    return content
  end

  # RSpecの正常系テストコードを作成するメソッド
  # ≒空欄でも保存できるか確認するexampleを作成する
  # 引数を変更している。未編集
  def make_normal_examples_html(normal_groups)
    html = ''
    normal_groups.each do |group| 
      # itの文章を作成する。it~<br>まで
      html += insert_space(6)
      html += "it '#{group[:column]}が空欄でも登録できる' do"
      html += '<br>'
      html += insert_space(8)
      html += "@#{group[:model]}.#{group[:column]} = ''"
      html += '<br>'
      html += insert_space(8)
      html += "expect(@#{group[:model]}).to be_valid"
      html += '<br>'
      html += insert_space(6)
      html += 'end'
      html += '<br>'
    end
    return html
  end

  # RSpecの異常系テストコードを作成するメソッド
  def make_abnormal_example_html(abnormal_groups, japanese)
    html = ''
    abnormal_groups.each do |group|
      html += insert_space(6)
      html += "it '#{group[:column]}#{group[:info]}' do"
      html += '<br>'
      html += insert_space(8)
      html += "@#{group[:model]}.#{group[:column]} = #{group[:change]}"
      html += '<br>'
      html += insert_space(8)
      html += "@#{group[:model]}.valid?"
      html += '<br>'
      html += insert_space(8)
      if japanese
        html += "expect(#{group[:model]}.errors.full_messages).to include(#{group[:message_ja]})"
      else
        html += "expect(#{group[:model]}.errors.full_messages).to include(#{group[:message_en]})"
      end
      html += '<br>'
      html += insert_space(6)
      html += 'end'
      html += '<br>'
    end
    return html
  end

  def test(model, gemfile)
    normal_groups = []
    abnormal_groups = []
    model.columns.each do |column|
      make_group_exist(model, column, abnormal_groups, normal_groups)
      make_group_options(model, column, abnormal_groups)
    end
    normal_example_html = make_normal_examples_html(normal_groups)
    abnormal_example_html = make_abnormal_example_html(abnormal_groups, gemfile.rails_i18n)
  
    test = {
      normal_example_html: normal_example_html,
      abnormal_example_html: abnormal_example_html
    }
    return test
  end

end

  

# メモ
devise_abnormal_group = [
  {name: 'email', info: 'が空欄だと登録できない', change: "''", message_ja: 'を入力してください', message_en: ''},
  {name: 'email', info: 'に@が含まれていない場合、登録できない', change: "'abcdefgh'", message_ja: 'を入力してください', message_en: ''},
  {name: 'password', info: 'が空欄だと登録できない', change: "''", message_ja: 'を入力してください', message_en: ''},
  {name: 'password', info: 'が空欄だと登録できない', change: "''", message_ja: 'を入力してください', message_en: ''},
  {name: 'password', info: 'が空欄だと登録できない', change: "''", message_ja: 'を入力してください', message_en: ''},
  {name: 'password', info: 'が空欄だと登録できない', change: "''", message_ja: 'を入力してください', message_en: ''},
  
]
# 重複があり登録できない -> 例外処理が必要