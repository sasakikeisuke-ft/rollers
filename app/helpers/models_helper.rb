module ModelsHelper
  # メインとなるHTML作成メソッド。
  def make_contents_html(model, gemfile)
    migration_html = ''
    validation_html = ''
    factorybot_html = ''
    presence_true = []
    presence_false = []
    boolean_group = []
    references_group = []
    valid_regerences_group = []
    activehash_group = []
    normal_groups = []
    abnormal_groups = []
    overlapping_groups = []

    # 取得したカラムごとに文章を作成していきます。eachメソッドは一回で済むようにします。
    model.columns.each do |column|
      # マイグレーションファイルのモデルごとの記載を作成します。
      migration_html += make_migration_html(column)

      # データ型とmust_existによって、追加先の配列を選択します。
      content = { name: column.name }
      # optionの表記が必要なグループを、さらにpresence: trueが必要かで追加先の配列を決めます
      content[:options] = make_options_html(column, gemfile.rails_i18n)
      if column.data_type_id <= 10
        presence_true << content if column.must_exist
        presence_false << content if !column.must_exist && content[:options] != ''
      else
        case column.data_type_id
        when 11
          boolean_group << content
        when 12
          references_group << content
          valid_regerences_group << content if content[:options] != ''
        when 13
          activehash_group << content
        end
      end

      # RSpecのための配列を作成します
      make_group_exist(model, column, abnormal_groups, normal_groups)
      make_group_options(model, column, abnormal_groups, overlapping_groups)

      # FactoryBotのためのHTMLを作成します。
      factorybot_html += make_factorybot_html(column)
    end
    # ここまでで作られた配列を基に、RSpecのグループへさらに追加する。
    make_group_references(references_group, model, abnormal_groups)
    make_activehash_example_html(activehash_group, model, abnormal_groups)
    # / ここまでで配列が完成しました。

    # ここから実際のHTMLをmake_validation_htmlメソッドを使用し作成します
    common = 'presence: true'
    validation_html += make_validation_html(presence_true, common)

    common = 'inclusion: { in: [true, false] }'
    validation_html += make_validation_html(boolean_group, common)

    common = 'numericality: { other_than: 0, message: "'
    common += "can't be blank"
    common += '"}'
    validation_html += make_validation_html(activehash_group, common)

    common = ''
    validation_html += make_validation_html(presence_false, common)
    validation_html += make_validation_html(valid_regerences_group, common)

    # アソシエーションのbelongs_toに関する記載を行います。
    belongs_to_html = make_belong(references_group, insert_space(2), false)
    activehash_html = make_belong(activehash_group, insert_space(2), true)

    # RSpecのexampleに関するHTMLを作成します
    normal_example_html = make_normal_examples_html(normal_groups)
    abnormal_example_html = make_abnormal_example_html(abnormal_groups, gemfile.rails_i18n)
    abnormal_example_html += make_overlapping_example_html(overlapping_groups, gemfile.rails_i18n)

    # FactoryBotのアソシエーションに関するHTMLを作成します。
    association_html = make_association_html(references_group)

    # 作成したHTMLをハッシュにしてビューファイルへ返します
    contents_html = {
      migration_html: migration_html,
      validation_html: validation_html,
      belongs_to_html: belongs_to_html,
      activehash_html: activehash_html,
      normal_example_html: normal_example_html,
      abnormal_example_html: abnormal_example_html,
      factorybot_html: factorybot_html,
      association_html: association_html
    }
  end

  # マイグレーションに記載する項目のHTMLを作成するメソッド。
  def make_migration_html(column)
    if column.data_type_id == 13
      ''
    else
      html = ''
      html += insert_space(6)
      html += "t.#{column.data_type.type} :#{column.name}"
      if column.data_type.type == 'references'
        html += ', foreign_key: true'
      else
        html += ', null: false' if column.must_exist
        html += ', unique: true' if column.unique
      end
      html += '<br>'
      html
    end
  end

  # バリデーションにおけるoptionのHTMLを作成するメソッド
  def make_options_html(column, japanese)
    html = ''
    column.options.each do |option|
      # ActiveHash app/models/option_type.rbのデータを使用しています。
      if option.option_type.type == 'format'
        html += option.option_type.code

      # オプションがnumericalityの場合は特別処理を行います。
      elsif option.option_type.type == 'numericality'
        html += ',<br>'
        html += insert_space(14)
        html += 'format: { with: /\A[0-9]+\z/, message: '
        html += if japanese
                  "'は半角数字を入力してください' },<br>"
                else
                  "'is invalid. Input harf-width numbers' },<br>"
                end
        html += insert_space(14)
        case option.option_type.info
        when '数値のみで登録する', '未選択状態での禁止'
          html += option.option_type.code
        when '上限下限を設定する'
          html += 'numericality: {greater_than_or_equal_to: '
          html += option.input1 unless option.input1.nil?
          html += '数値' if option.input1.nil?
          html += ', less_than_or_equal_to: '
          html += option.input2 unless option.input2.nil?
          html += '数値' if option.input2.nil?
          html += ', message: '
        when '上限のみを設定する'
          html += 'numericality: {less_than_or_equal_to: '
          html += option.input1 unless option.input1.nil?
          html += '数値' if option.input1.nil?
          html += ', message: '
        when '上限下限を設定する'
          html += 'numericality: {greater_than_or_equal_to: '
          html += option.input2 unless option.input2.nil?
          html += '数値' if option.input2.nil?
          html += ', message: '
        end
      elsif option.option_type.type == 'uniqueness'
        html += "#{option.option_type.code}#{option.input1}"
        html += ", :#{option.input2}" if option.option_type.info == '複数のモデルでの重複禁止'
        html += ', message: '
      end

      # エラーメッセージを追加します
      html += '"'
      html += make_message_html(option, japanese)
      html += '" }'
    end
    html
  end

  # エラー文日本語化を設定しているかどうかで、エラー文を選択するメソッド。
  def make_message_html(option, japanese)
    html = if japanese
             option.option_type.message_ja
           else
             option.option_type.message_en
           end
  end

  # with_optionsが使用できるかどうかで記載形態を変更するメソッド
  def make_validation_html(array, common)
    html = ''
    if array.length == 0
      return ''
    elsif array.length == 1 || common == ''
      array.each do |element|
        html += insert_space(2)
        html += 'validates :'
        html += element[:name]
        html += ', '
        html += common
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

    html
  end

  # references型カラム名からbelongs_toの対象を定め、HTMLを作成するメソッド。
  def make_belong(array, before, activehash)
    return if array.length == 0

    html = ''
    if activehash
      html += '<br>'
      html += before
      html += 'extend ActiveHash::Associations::ActiveRecordExtensions'
      html += '<br>'
    end
    array.each do |element|
      html += before
      html += 'belongs_to :'
      html += element[:name]
      html += '<br>'
    end
    html
  end

  # アソシエーションのhas_many/has_oneを作成するメソッド
  # 中間メソッドの場合に必要な追記も組み込んでいます
  def make_has(columns, model)
    html = ''
    columns.each do |column|
      # 以下の条件が合った場合にのみ処理を行う。
      next unless column.name == model.name

      html += insert_space(2)
      html += if model.not_only
                'has_many :'
              else
                'has_one :'
              end
      target = column.model
      html += target.name.tableize
      html += '<br>'
      # 中間テーブルの場合、
      # 動作確認が未実施。今後エラーの可能性があり注意が必要。
      next unless target.model_type_id == 3

      target_columns = target.columns.where.not(name: model.name)
      target_columns.each do |tie|
        html += insert_space(2)
        html += 'has_many :'
        html += tie.name
        html += ', through: :'
        html += target.name
        html += '<br>'
      end
    end
    html
  end

  # 以下はRSpecに関するメソッド

  # カラムを受け取ってexampleのための配列を作成するメソッド
  def make_group_exist(model, column, abnormal_groups, normal_groups)
    content = { model: model.name, column: column.name, column_ja: column.name_ja }
    if [12, 13].include?(column.data_type_id)
      nil
    elsif column.must_exist
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
  def make_group_options(model, column, abnormal_groups, overlapping_groups)
    column.options.each do |option|
      case option.option_type.type
      when 'format'
        # 数字が含まれる場合に対するexample
        if [11, 12, 13, 15, 16, 17].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に数字が含まれていると保存できない'
          content[:change] = "'12345678'"
          abnormal_groups << content
        end
        # 英字が含まれる場合に対するexample
        if [11, 12, 13, 14, 20].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に英字が含まれていると保存できない'
          content[:change] = "'abcdEFGH'"
          abnormal_groups << content
        end
        # 英字小文字が含まれる場合に対するexample
        if [17].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に英字小文字が含まれていると保存できない'
          content[:change] = "'abcdefgh'"
          abnormal_groups << content
        end
        # 英字大文字が含まれる場合に対するexample
        if [16].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に英字大文字が含まれていると保存できない'
          content[:change] = "'ABCDEFGH'"
          abnormal_groups << content
        end
        # 漢字が含まれる場合に対するexample
        if [12, 13, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'に漢字が含まれていると保存できない'
          content[:change] = "'漢字漢字漢字漢字'"
          abnormal_groups << content
        end
        # ひらがなが含まれる場合に対するexample
        if [13, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'にひらがなが含まれていると保存できない'
          content[:change] = "'ひらがなひらがな'"
          abnormal_groups << content
        end
        # カタカナが含まれる場合に対するexample
        if [12, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'にカタカナが含まれていると保存できない'
          content[:change] = "'カタカナカタカナ'"
          abnormal_groups << content
        end
      when 'numericality'
        if [22, 24].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'が設定した数値より大きいと保存できない'
          content[:change] = (option.input1 + 1).to_s
          abnormal_groups << content
        end
        if [22, 23].include?(option.option_type_id)
          content = group_of_base(model, column, option)
          content[:info] = 'が設定した数値より小さいと保存できない'
          content[:change] = (option.input2 - 1).to_s
          abnormal_groups << content
        end
      when 'uniqueness'
        content = group_of_base(model, column, option)
        content[:info] = 'の重複があり登録できない'
        content[:change] = option.input1
        overlapping_groups << content
      end
    end
  end

  # combination_of_optionの重複部分をまとめるメソッド
  def group_of_base(model, column, option)
    {
      model: model.name,
      column: column.name,
      column_ja: column.name_ja,
      message_ja: option.option_type.message_ja,
      message_en: option.option_type.message_en
    }
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
    html
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
      html += if japanese
                "expect(#{group[:model]}.errors.full_messages).to include('#{group[:column_ja]}#{group[:message_ja]}')"
              else
                "expect(#{group[:model]}.errors.full_messages).to include('#{group[:column]}#{group[:message_en]}')"
              end
      html += '<br>'
      html += insert_space(6)
      html += 'end'
      html += '<br>'
    end
    html
  end

  # references_groupを基に、紐付けに関するexampleの組み合わせを作成するメソッド
  def make_group_references(references_group, model, abnormal_groups)
    references_group.each do |group|
      content = {}
      content[:model] = model.name
      content[:column] = group[:name]
      content[:column_ja] = group[:name]
      content[:info] = 'が紐づけられていないと登録できない'
      content[:change] = 'nil'
      content[:message_ja] = ' must exist'
      content[:message_en] = ' must exist'
      abnormal_groups << content
    end
  end

  # activehash_groupを基に、必要なexampleを作成する組み合わせを作成するメソッド
  def make_activehash_example_html(activehash_group, model, abnormal_groups)
    activehash_group.each do |group|
      content = {}
      content[:model] = model.name
      content[:column] = group[:name]
      content[:column_ja] = group[:name]
      content[:info] = 'が空欄だと登録できない'
      content[:change] = ''
      content[:message_ja] = ' must exist'
      content[:message_en] = ' must exist'
      abnormal_groups << content

      content = {}
      content[:model] = model.name
      content[:column] = group[:name]
      content[:column_ja] = group[:name]
      content[:info] = 'が未選択だと登録できない'
      content[:change] = 0
      content[:message_ja] = ' must exist'
      content[:message_en] = ' must exist'
      abnormal_groups << content
    end
  end

  # 重複保存禁止に関するexampleのhtmlを作成するメソッド
  def make_overlapping_example_html(overlapping_groups, japanese)
    html = ''
    overlapping_groups.each do |group|
      html += insert_space(6)
      html += "it '#{group[:column]}#{group[:info]}' do"
      html += '<br>'
      html += insert_space(8)
      html += "@#{group[:model]}.save"
      html += '<br>'
      html += insert_space(8)
      html += "another_#{group[:model]} = FactoryBot.build(:#{group[:model]}, #{group[:column]}: @#{group[:model]}.#{group[:column]})"
      html += '<br>'
      html += insert_space(8)
      html += "another_#{group[:model]}.valid?"
      html += '<br>'
      html += insert_space(8)
      html += if japanese
                "expect(#{group[:model]}.errors.full_messages).to include('#{group[:column]}#{group[:message_ja]}')"
              else
                "expect(#{group[:model]}.errors.full_messages).to include('#{group[:column]}#{group[:message_en]}')"
              end
      html += '<br>'
      html += insert_space(6)
      html += 'end'
      html += '<br>'
    end
    html
  end

  # FactoryBotで使用するFaker及びGimeiのHTMLを作成するメソッド
  def make_factorybot_html(column)
    return '' if column.data_type_id == 12

    html = "#{insert_space(4)}#{column.name} { "
    case column.data_type_id
    when 1 # 'string'
      if column.options.length != 0
        column.options.each do |option|
          case option.option_type.info
          when '漢字かなカナで登録可'
            html += 'Gimei.kanji }'
          when 'ひらがなのみで登録可'
            html += 'Gimei.hiragana }'
          when 'カタカナのみで登録可'
            html += 'Gimei.katakana }'
          when '郵便番号形式で登録可'
            html += "'123-4567'}"
          when '対象モデル内での重複禁止', '複数のモデルでの重複禁止'
            unique_count = true
          end
        end
      else
        html += 'Faker::Lorem.characters(number: 8) }'
      end
    when 2 # 'text'
      html += 'Faker::Lorem.sentence }'
    when 3 # 'integer'
      if column.options.length != 0
        column.options.each do |option|
          case option.option_type.info
          when '数値のみで登録する'
            html += 'Faker::Number(digits: 8) }'
          when '上限下限を設定する'
            html += 'Faker::Number.within(range: '
            html += option.input2 unless option.input2.nil?
            html += '..'
            html += option.input1 unless option.input1.nil?
            html += ') }'
          when '上限のみを設定する'
            html += 'Faker::Number.within(range: '
            html += '0..'
            html += option.input1 unless option.input1.nil?
            html += ') }'
          when '下限のみを設定する'
            html += 'Faker::Number.within(range: '
            html += option.input2 unless option.input2.nil?
            html += '..10000000'
            html += ') }'
          when '未選択状態での禁止'
            html += 'Faker::Number.non_zero_digit }'
          else
            html += 'Faker::Number(digits: 8) }'
          end
        end
      else
        html += 'Faker::Number(digits: 8) }'
      end
    when 4, 5 # 'decimal', 'float'
      html += 'Faker::Number.decimal(l_digits: 3, r_digits: 3) }'
    when 6 # 'date'
      html += 'Faker::Date.between(from: 50.years.ago, to: Date.today) }'
    when 7 # 'time'
      html += 'Faker::Time.between(DateTime.now - 1, DateTime.now).strftime("%H:%M:%S") }'
    when 8 # 'datetime'
      html += 'Faker::Time.between(DateTime.now - 1, DateTime.now) }'
    when 11 # 'boolean'
      html += 'Faker::Boolean.boolean }'
    when 13 # 'ActiveHash' refarences型はここでは記載不要だがassociationに記載が必要
      html += 'Faker::Number.non_zero_digit }'
    end
    html += '<br>'
    html
  end

  # FactoryBotのアソシエーションを作成するメソッド
  def make_association_html(groups)
    html = ''
    groups.each do |group|
      html += insert_space(4)
      html += 'association :'
      html += group[:name]
      html += '<br>'
    end
    html
  end

  # ActiveHashのHTMLを作成するメソッド
  def make_activehash_html(model, columns)
    html = "class = #{model.name.classify}"
    html += '<br>'
    html += "#{insert_space(2)}self.data = ["
    html += '<br>'
    before = "#{insert_space(4)}{ id: "
    center = ''
    model.columns.each do |column|
      center += ', '
      center += column.name
      center += ": ''"
    end
    after = ' }'
    content = '--'
    6.times do |i|
      content = '内容' if i >= 1
      content = '最後' if i == 5
      html += "#{before}#{i}#{center}#{content}#{after}"
      html += ',' if i != 5
      html += '<br>'
    end
    html += insert_space(2)
    html += ']'
    html += '<br>'
    html += insert_space(2)
    html += 'include ActiveHash::Associations'
    html += insert_space(2)
    html += make_has(columns, model)
    html
  end

  # Formオブジェクトパターンに関するHTMLを記載するメソッド
  def make_formobject_html(model, gemfile)
    target_models = []
    all_columns = []

    model.columns.each do |column|
      target_model = Model.includes(columns: :options).find_by(name: column.name)
      target_models << target_model
    end
    target_models.each do |target_model|
      target_model.columns.each do |column|
        all_columns << column
      end
    end

    validation_html = ''
    factorybot_html = ''
    presence_true = []
    presence_false = []
    boolean_group = []
    references_group = []
    valid_regerences_group = []
    activehash_group = []
    normal_groups = []
    abnormal_groups = []
    overlapping_groups = []

    # 取得したカラムごとに文章を作成していきます。eachメソッドは一回で済むようにします。
    all_columns.each do |column|
      # データ型とmust_existによって、追加先の配列を選択します。
      content = { name: column.name }
      # optionの表記が必要なグループを、さらにpresence: trueが必要かで追加先の配列を決めます
      content[:options] = make_options_html(column, gemfile.rails_i18n)
      if column.data_type_id <= 10
        presence_true << content if column.must_exist
        presence_false << content if !column.must_exist && content[:options] != ''
      else
        case column.data_type_id
        when 11
          boolean_group << content
        when 12
          references_group << content
          valid_regerences_group << content if content[:options] != ''
        when 13
          activehash_group << content
        end
      end

      # RSpecのための配列を作成します
      make_group_exist(model, column, abnormal_groups, normal_groups)
      make_group_options(model, column, abnormal_groups, overlapping_groups)

      # FactoryBotのためのHTMLを作成します。
      factorybot_html += make_factorybot_html(column)
    end
    # ここまでで作られた配列を基に、RSpecのグループへさらに追加する。
    make_group_references(references_group, model, abnormal_groups)
    make_activehash_example_html(activehash_group, model, abnormal_groups)
    # / ここまでで配列が完成しました。

    # ここから実際のHTMLをmake_validation_htmlメソッドを使用し作成します
    common = 'presence: true'
    validation_html += make_validation_html(presence_true, common)

    common = 'inclusion: { in: [true, false] }'
    validation_html += make_validation_html(boolean_group, common)

    common = 'numericality: { other_than: 0, message: "'
    common += "can't be blank"
    common += '"}'
    validation_html += make_validation_html(activehash_group, common)

    common = ''
    validation_html += make_validation_html(presence_false, common)
    validation_html += make_validation_html(valid_regerences_group, common)

    # RSpecのexampleに関するHTMLを作成します
    normal_example_html = make_normal_examples_html(normal_groups)
    abnormal_example_html = make_abnormal_example_html(abnormal_groups, gemfile.rails_i18n)
    abnormal_example_html += make_overlapping_example_html(overlapping_groups, gemfile.rails_i18n)

    # 作成したHTMLをハッシュにしてビューファイルへ返します
    {
      validation_html: validation_html,
      normal_example_html: normal_example_html,
      abnormal_example_html: abnormal_example_html,
      factorybot_html: factorybot_html,
      attr_accessor_html: make_attr_accessor_html(all_columns),
      save_html: make_save_html(target_models)
    }
  end

  def make_attr_accessor_html(all_columns)
    html = 'attr_accessor :'
    count = 0
    all_columns.each do |column|
      html += ',' if count != 0
      html += " :#{column.name}"
      count += 1
    end
    html
  end

  def make_save_html(target_models)
    html = ''
    target_models.each do |model|
      count = 0
      html += insert_space(4)
      html += "#{model.name.classify}.create("
      model.columns.each do |column|
        html += ', ' if count != 0
        html += if column.data_type_id != 12
                  "#{column.name}: #{column.name}"
                else
                  "#{column.name}_id: #{column.name}_id"
                end
        count += 1
      end
      html += ')'
      html += '<br>'
    end
    html
  end

  def make_group_exist_exception(abnormal_groups, references_group)
    references_group.each do |content|
      content[:info] = 'が空欄だと登録できない'
      content[:change] = "''"
      content[:message_ja] = 'を入力してください'
      content[:message_en] = "is can't be blank"
      abnormal_groups << content
    end
  end
end
