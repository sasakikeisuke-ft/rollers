module ModelsHelper
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

  #   model#showのコード表示機能に関するメソッド
  ##  計画: contentsにハッシュ構造を持たせ、引数として使用することで複数のメソッドに渡って受け渡すことができるようにする。
  ### contentsのハッシュ一覧とその内容について
  ### contents[:presence_true] -> 空欄禁止として登録したカラムを格納する。バリデーションの作成に必要。
  ### contents[:presence_false] -> 空欄禁止として登録せず、optionの登録がされているカラムを格納する。上記と別の処理を行う。
  ### contents[:boolean_group] -> 上記とは別にboolean型のカラムを格納する。バリデーションの処理が異なるため別の配列に格納する。
  ### contents[:references_group] -> references型のカラムを格納する。この配列を参考にアソシエーションに関する記載を行う。
  ### contents[:activehash_group] -> activehash型のカラムを格納する。データ型をintegerに固定し、また専用のアソシエーションを記載する。
  ### contents[:japanese] -> gemfileにて、日本語化ファイルを適応するかどうかの情報を格納する。
  ### contents[:all_columns] -> 全てのカラムを格納する。FactoryBotに関するコード作成に必要。

  # 配列を作成するメソッド
  def make_model_array(model, gemfile)
    contents = make_model_array_template
    contents[:japanese] = gemfile.rails_i18n

    target_columns = if model.model_type.name != 'Formオブジェクト'
                       model.columns
                     else # Formオブジェクトの場合、特別な処理により、対象としているモデルのカラムが全てを取得する
                       make_form_object(model, contents)
                     end

    # 取得したカラムを配列へと振り分けていく。
    target_columns.each do |column|
      if column.data_type_id <= 10
        if column.must_exist
          contents[:presence_true] << column
        elsif !column.options.empty?
          contents[:presence_false] << column
          contents[:normal_example_group] << column
        else # 空欄可能であり、かつオプションの設定がされていない場合
          contents[:normal_example_group] << column
        end
      else
        case column.data_type.type
        when 'boolean'
          contents[:boolean_group] << column
        when 'references'
          contents[:references_group] << column
        when 'ActiveHash'
          contents[:activehash_group] << column
        end
      end
      contents[:all_columns] << column
    end
    contents[:presence_true] += contents[:references_group] if model.model_type.name == 'ActiveHash'
    contents[:presence_true] += contents[:activehash_group]
    contents
  end

  # contentsのハッシュに紐づけられた空の配列を作成するメソッド。make_model_arrayの事前準備として使用する。
  def make_model_array_template
    categorcies = %w[
      presence_true presence_false
      boolean_group references_group activehash_group
      normal_example_group all_columns
    ]
    contents = {}
    categorcies.each do |category|
      contents[category.to_sym] = []
    end
    contents
  end

  # モデルファイルのバリデーションに関する記載を作成するメソッド
  def make_validation(contents, japanese)
    result = ''
    space = 2

    # 空欄禁止を設定されたものから処理を行う。
    option_code = 'presence: true'
    result += use_with_option?(contents[:presence_true], space, japanese, option_code)

    # 空欄を禁止せずoptionのみ設定されたgroupの処理を行う。
    result += make_with_options(contents[:presence_false], space, japanese)

    # boolean型のグループに関するvalidationを記載する。
    option_code = 'inclusion:{in: [true, false]}'
    result += use_with_option?(contents[:boolean_group], space, japanese, option_code)

    # 最終的なHTMLを返却する
    result
  end

  # with_optionを使用するかどうかを判断し、必要に応じてメソッドを使用するメソッド
  def use_with_option?(group, space, japanese, option_code)
    result = ''
    if group.length >= 2
      result += "#{insert_space(space)}with_options #{option_code} do<br>"
      result += make_with_options(group, space + 2, japanese)
      result += "#{insert_space(space)}end<br>"
    elsif group.length == 1
      result += "#{insert_space(space)}validates :#{group[0].name}, #{option_code}"
      group[0].options.each do |option|
        result += make_options(option, japanese)
      end
      result += '<br>'
    end
    result
  end

  # optionに関する記載を行うメソッド。そのカラムのオプションのみ追加していく。
  def make_options(option, japanese)
    code = option.option_type.code
    code = code.gsub(/入力1/, option.input1) unless option.input1 == ''
    code = code.gsub(/入力2/, option.input2) unless option.input2 == ''
    code = if japanese
             code.gsub(/エラーメッセージ/, option.option_type.message_ja)
           else
             code.gsub(/エラーメッセージ/, option.option_type.message_en)
           end
    ", #{code}"
  end

  def make_with_options(group, space, japanese)
    result = ''
    content = { else: [], single: [] }
    grouping_ids = [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 25]
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
      else # column.data_type.type == 'ActiveHash'
        content[:option_type_25] = [] if content[:option_type_25].nil?
        content[:option_type_25] << column
      end
    end

    # 分配した配列をもとにバリデーションを作成する。
    grouping_ids.each do |id|
      next if content["option_type_#{id}".to_sym].nil?

      if content["option_type_#{id}".to_sym].length >= 2
        option_type = OptionType.find(id)
        code = if japanese
                 option_type.code.gsub(/エラーメッセージ/, option_type.message_ja)
               else
                 option_type.code.gsub(/エラーメッセージ/, option_type.message_en)
               end
        before = "#{insert_space(space)}with_options #{code} do<br>"
        after = "#{insert_space(space)}end<br>"
        during = ''
        content["option_type_#{id}".to_sym].each do |column|
          name = if column.data_type.type == 'ActiveHash'
                   "#{column.name}_id"
                 else
                   column.name
                 end
          during += "#{insert_space(space + 2)}validates :#{name}"
          column.options.each do |option|
            next if grouping_ids.include?(option.option_type_id)

            during += make_options(option, japanese)
          end
          during += '<br>'
        end
        result += before + during + after
      else # if content["option_type_#{id}".to_sym].length == 1
        content[:single] += content["option_type_#{id}".to_sym]
      end
    end

    # formatを使用していないカラムのバリデーションを記載する。
    content[:single] += content[:else]
    content[:single].each do |column|
      result += "#{insert_space(space)}validates :#{column.name}"
      column.options.each do |option|
        result += make_options(option, japanese)
      end
      result += '<br>'
    end
    result
  end

  # アソシエーションに関する記述を作成するメソッド
  def make_association(contents, columns, model, attached_image)
    result = ''
    space = 2

    # belongs_toに関する記述を作成する。
    contents[:references_group].each do |column|
      result += "#{insert_space(2)}belongs_to :#{column.name}<br>"
    end

    # has_many/has_oneに関する記述を作成する。ここでのcolumnsはアプリに関連する全てのカラムが対象となっている。
    columns.each do |column|
      # このモデル名と同じカラム名である -> references型で対象がこのモデル -> 対象モデルではbelongs_toが記載されている。
      next unless column.name == model.name

      has = if model.not_only
              'has_many :'
            else
              'has_one :'
            end
      target_model = column.model
      result += "#{insert_space(space)}#{has}#{target_model.name.tableize}, dependent: :destroy<br>"

      # target_modelが中間テーブルの場合、追加処理を行う。
      next unless target_model.model_type_id == 3

      target_columns = target_model.columns.where.not(name: model.name)
      target_columns.each do |target_column|
        result += "#{insert_space(space)}has_many :#{target_column.name}"
        result += ", through: :#{target_model.name}<br>"
      end
    end

    # ImageMagickを使用する場合のアソシエーションを記載
    result += "#{insert_space(2)}has_one_attached :image<br>" if attached_image

    # ActiveHashに関する記述を作成するメソッド。
    unless contents[:activehash_group].empty?
      result += "<br>#{insert_space(2)}# ActiveHash<br>"
      result += "#{insert_space(2)}extend ActiveHash::Associations::ActiveRecordExtensions<br>"
      contents[:activehash_group].each do |column|
        result += "#{insert_space(2)}belongs_to :#{column.name}<br>"
      end
    end
    result
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

    # モデルごとにカラムの処理を行う。この時点でattr_accessorのための配列を作成する
    accessor_names = []
    contents[:save] = "<br>#{insert_space(2)}def save<br>"
    target_models.each do |target_model|
      contents[:save] += "#{insert_space(4)}#{target_model.name} = #{target_model.name.classify}.create("
      save_first = true
      target_columns.each do |column|
        next unless column.model_id == target_model.id

        # contents[:attr_accessor]に重複して表示しない処理のために、カラム名を専用の配列へ格納する。
        accessor_names << if %w[references ActiveHash].include?(column.data_type.type)
                            "#{column.name}_id"
                          else
                            column.name
                          end

        # contents[:save]にsaveメソッドに関する記述を作成し格納する。
        contents[:save] += ', ' unless save_first
        contents[:save] += if target_model_names.include?(column.name)
                             "#{column.name}_id: #{column.name}.id"
                           elsif %w[references ActiveHash].include?(column.data_type.type)
                             "#{column.name}_id: #{column.name}_id"
                           else
                             "#{column.name}: #{column.name}"
                           end
        save_first = false
      end
      contents[:save] += ')<br>'
    end
    contents[:save] += "#{insert_space(2)}end<br>"

    # attr_accessorの記述を作成する。
    contents[:attr_accessor] = "#{insert_space(2)}attr_accessor "
    accessor_first = true
    accessor_names.uniq.each do |name|
      contents[:attr_accessor] += ', ' unless accessor_first
      contents[:attr_accessor] += ":#{name}"
      accessor_first = false
    end
    contents[:attr_accessor] += '<br><br>'

    target_columns
  end

  # Formオブジェクトに関連するFactryBotに関する記述を作成するメソッド
  def add_bot(contents)
    result = ''
    names = []
    contents[:references_group].each do |column|
      names << column.name
    end
    names.uniq.each do |name|
      result += "#{insert_space(4)}#{name} = FactoryBot.create(:#{name})<br>"
    end
    result
  end

  # RSpec正常系のテストコードを作成するメソッド
  def make_normal_example(contents, model)
    result = ''
    contents[:normal_example_group].each do |column|
      result += "#{insert_space(6)}it '#{column.name}が空欄でも登録できる' do<br>"
      result += "#{insert_space(8)}@#{model.name}.#{column.name} = ''<br>"
      result += "#{insert_space(8)}expect(@#{model.name}).to be_valid<br>"
      result += "#{insert_space(6)}end<br>"
    end
    result
  end

  # RSpec異常系のテストコードを作成するメソッド
  def make_abnormal_example(contents, model, japanese)
    result = ''

    # 空欄禁止とそのオプションに関するテストコード
    contents[:presence_true].each do |column|
      base = make_abnormal_example_template(column, model.name, japanese)
      sample = base.gsub(/条件/, 'が空欄だと登録できない')
      sample = sample.gsub(/変更点/, "''")
      sample = if japanese
                 sample.gsub(/メッセージ/, 'を入力してください')
               else
                 sample.gsub(/メッセージ/, " is can't be blank")
               end
      result += sample
      result += make_option_example(column, model.name, japanese, base)
    end

    # オプションのみ設定されているカラムのテストコード
    contents[:presence_false].each do |column|
      base = make_abnormal_example_template(column, model.name, japanese)
      result += make_option_example(column, model.name, japanese, base)
    end

    # references型カラムのテストコード
    contents[:references_group].each do |column|
      base = make_abnormal_example_template(column, model.name, japanese)
      sample = base.gsub(/条件/, 'が紐づけられていないと登録できない')
      sample = sample.gsub(/変更点/, 'nil')
      sample = sample.gsub(/メッセージ/, ' must exist')
      result += sample
      result += make_option_example(column, model.name, japanese, base)
    end

    # ActiveHashを選択したカラムのテストコード
    contents[:activehash_group].each do |column|
      base = make_abnormal_example_template(column, model.name, japanese)
      sample = base.gsub(/条件/, 'が未選択だと登録できない')
      sample = sample.gsub(/変更点/, '0')
      sample = sample.gsub(/メッセージ/, " can't be blank")
      result += sample
    end
    result
  end

  # 異常系テストコードの原型を作成するメソッド
  def make_abnormal_example_template(column, model_name, japanese)
    column_name = if %w[references ActiveHash].include?(column.data_type.type)
                    "#{column.name}_id"
                  else
                    column.name
                  end
    display_name = if japanese && column.name_ja != ''
                     column.name_ja
                   else
                     column.name.titleize
                   end
    base = "#{insert_space(6)}it '#{column_name}条件' do<br>"
    base += "#{insert_space(8)}@#{model_name}.#{column_name} = 変更点<br>"
    base += "#{insert_space(8)}@#{model_name}.valid?<br>"
    base += "#{insert_space(8)}expect(@#{model_name}.errors.full_message).to include("
    base += '"表示名メッセージ")<br>'.sub(/表示名/, display_name)
    base += "#{insert_space(6)}end<br>"
    base
  end

  # カラムの登録内容から必要なテストコードを作成するメソッド
  ## 対象により必要な内容が微妙に異なるため不採用
  # def make_column_example(infomation, model_name, japanese)
  #   result = ''
  #   infomation[:group].each do |column|
  #     base = make_abnormal_example_template(column, model_name, japanese)
  #     sample = base.gsub(/条件/, infomation[:condition])
  #     sample = sample.gsub(/変更点/, infomation[:change])
  #     if japanese
  #       sample = sample.gsub(/メッセージ/, infomation[:message_ja])
  #     else
  #       sample = sample.gsub(/メッセージ/, infomation[:message_en])
  #     end
  #     result += sample
  #     result += make_option_example(column, japanese, base)
  #   end
  #   result
  # end

  # そのカラムに登録されているオプションに対応したテストコードを作成する。
  def make_option_example(column, model_name, japanese, base)
    result = ''
    column.options.each do |option|
      case option.option_type.type
      when 'format'
        # 数字が含まれる場合に対するexample
        if [11, 12, 13, 15, 16, 17].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'に数字が含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'12345678'")
          result += sample
        end
        # 英字が含まれる場合に対するexample
        if [11, 12, 13, 14, 20].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'に英字が含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'abcdEFGH'")
          result += sample
        end
        # 英字小文字が含まれる場合に対するexample
        if [17].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'に英字小文字が含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'abcdefgh'")
          result += sample
        end
        # 英字大文字が含まれる場合に対するexample
        if [16].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'に英字大文字が含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'ABCDEFGH'")
          result += sample
        end
        # 漢字が含まれる場合に対するexample
        if [12, 13, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'に漢字が含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'漢字漢字漢字漢字'")
          result += sample
        end
        # ひらがなが含まれる場合に対するexample
        if [13, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'にひらがなが含まれていると保存できない')
          sample = sample.gsub(/変更点/, "'ひらがなひらがな'")
          result += sample
        end
        # カタカナが含まれる場合に対するexample
        if [12, 14, 15, 16, 17, 18, 19, 20].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'にカタカナが含まれていると保存できない')
          sample = sample.gsub(/変更点/, 'カタカナカタカナ')
          result += sample
        end
      when 'numericality'
        if [22, 24].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'が設定した数値より大きいと保存できない')
          sample = sample.gsub(/変更点/, option.input1 + 1)
          result += sample
        end
        if [22, 23].include?(option.option_type_id)
          sample = base.gsub(/条件/, 'が設定した数値より小さいと保存できない')
          sample = sample.gsub(/変更点/, option.input1 - 1)
          result += sample
        end
      when 'uniqueness'
        # 重複確認のテストコードではbaseの形が異なるため、専用のbaseを作成する
        column_name = if %w[references ActiveHash].include?(column.data_type.type)
                        "#{column.name}_id"
                      else
                        column.name
                      end
        display_name = if japanese && column.name_ja != ''
                         column.name_ja
                       else
                         column.name.titleize
                       end
        sample = "#{insert_space(6)}it '#{column_name}の重複があり登録できない' do<br>"
        sample += "#{insert_space(8)}@#{model_name}.save<br>"
        sample += "#{insert_space(8)}another_#{model_name} = FactoryBot.build(:#{model_name}, "
        sample += "#{column_name}: @#{model_name}.#{column_name}変更点)<br>"
        sample += "#{insert_space(8)}another_#{model_name}.valid?<br>"
        sample += "#{insert_space(8)}expect(@#{model_name}.errors.full_message).to include("
        sample += '"表示名メッセージ")<br>'.sub(/表示名/, display_name)
        sample += "#{insert_space(6)}end<br>"
        case option.option_type_id
        when 41
          sample = sample.sub(/変更点/, '')
        when 42
          sample = sample.sub(/変更点/, ", #{option.input1}: @#{model_name}.#{option.input1}")
        when 43
          change = ", #{option.input1}_id: @#{model_name}.#{option.input1}_id"
          change += ", #{option.input2}_id: @#{model_name}.#{option.input2}_id"
          sample = sample.sub(/変更点/, change)
        end
        result += sample
      end

      # エラーメッセージの変更 -> オプションごとにエラーメッセージは固定
      result = if japanese
                 result.gsub(/メッセージ/, option.option_type.message_ja)
               else
                 result.gsub(/メッセージ/, option.option_type.message_en)
               end
    end
    result
  end

  # FactoryBotで使用するFaker及びGimeiのHTMLを作成するメソッド
  def make_factorybot_html(contents)
    result = ''
    contents[:all_columns].each do |column|
      next if column.data_type_id == 12

      result += "#{insert_space(4)}#{column.name}"
      case column.data_type_id
      when 1 # 'string'
        if !column.options.empty?
          done = false
          column.options.each do |option|
            next unless option.option_type.type == 'format'

            done = true
            case option.option_type.info
            when '漢字かなカナで登録可'
              result += ' { Gimei.kanji }'
            when 'ひらがなのみで登録可'
              result += ' { Gimei.hiragana }'
            when 'カタカナのみで登録可'
              result += ' { Gimei.katakana }'
            when '数字のみ限定で登録可'
              result += ' { 12345678 }'
            when '英字のみ限定で登録可'
              result += " { 'abcdEFGH' }"
            when '英字小文字のみ登録可'
              result += " { 'abcdefgh' }"
            when '英字大文字のみ登録可'
              result += " { 'ABCDEFGH }"
            when '英字数字のみで登録可'
              result += " { '1234ABcd'}"
            when '郵便番号形式で登録可'
              result += " { '123-4567'}"
            end
          end
          result += ' { Faker::Lorem.characters(number: 8) }' unless done
        else
          result += ' { Faker::Lorem.characters(number: 8) }'
        end
      when 2 # 'text'
        result += ' { Faker::Lorem.sentence }'
      when 3 # 'integer'
        if !column.options.empty?
          column.options.each do |option|
            case option.option_type.info
            when '上限下限を設定する'
              sample = ' { Faker::Number.within(range: 入力2..入力1) }'
              sample = sample.gsub(/入力2/, option.input2) unless option.input2.nil?
              sample = sample.gsub(/入力1/, option.input1) unless option.input1.nil?
              result += sample
            when '上限のみを設定する'
              sample = ' { Faker::Number.within(range: 0..入力1) }'
              sample = sample.gsub(/入力1/, option.input1) unless option.input1.nil?
              result += sample
            when '下限のみを設定する'
              sample = ' { Faker::Number.within(range: 入力2..10000000) }'
              sample = sample.gsub(/入力2/, option.input2) unless option.input2.nil?
              result += sample
            when '未選択状態での禁止'
              result += ' { Faker::Number.non_zero_digit }'
            else
              result += ' { Faker::Number(digits: 8) }'
            end
          end
        else
          result += ' { Faker::Number(digits: 8) }'
        end
      when 4, 5 # 'decimal', 'float'
        result += ' { Faker::Number.decimal(l_digits: 3, r_digits: 3) }'
      when 6 # 'date'
        result += ' { Faker::Date.between(from: 50.years.ago, to: Date.today) }'
      when 7 # 'time'
        result += ' { Faker::Time.between(DateTime.now - 1, DateTime.now).strftime("%H:%M:%S") }'
      when 8 # 'datetime'
        result += ' { Faker::Time.between(DateTime.now - 1, DateTime.now) }'
      when 11 # 'boolean'
        result += ' { Faker::Boolean.boolean }'
      when 13 # 'ActiveHash' refarences型はここでは記載不要だがassociationに記載が必要
        result += '_id { Faker::Number.non_zero_digit }'
      end
      result += '<br>'
    end
    result
  end

  # FactoryBotのアソシエーションを作成するメソッド
  def make_association_html(contents)
    result = ''
    names = []
    contents[:references_group].each do |column|
      names << column.name
    end
    names.uniq.each do |name|
      result += "#{insert_space(4)}association :#{name}<br>"
    end
    result
  end

  # ActiveHashにおける要素を作成する専用メソッド
  def make_activehash_code(model)
    base = "#{insert_space(4)}{ id: 数値"
    model.columns.each do |column|
      base += ", #{column.name}: '内容'"
    end
    base += ' }'
    result = ''
    first = true
    6.times do |i|
      result += ', <br>' unless first
      sample = base.gsub(/数値/, i.to_s)
      sample = sample.gsub(/内容/, "'----'") if i.zero?
      sample = sample.gsub(/内容/, "'最後'") if i == 5
      result += sample
      first = false
    end
    result += '<br>'
    result
  end

  # ActiveHashにおけるアソシエーションを作成する専用メソッド
  def make_activehash_has(columns, model_name)
    result = ''
    columns.each do |column|
      # このモデル名と同じカラム名である -> references型で対象がこのモデル -> 対象モデルではbelongs_toが記載されている。
      next unless column.name == model_name

      target_model = column.model
      result += "#{insert_space(2)}has_many :#{target_model.name.tableize}<br>"
    end
    result
  end
end
