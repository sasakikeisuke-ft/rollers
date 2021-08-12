module TestsHelper
  end


  ##  計画: contentsにハッシュ構造を持たせ、引数として使用することで複数のメソッドに渡って受け渡すことができるようにする。
  ### contentsのハッシュ一覧とその内容について
  ### contents[:presence_true] -> 登録時に空欄禁止として登録したカラムを格納する。バリデーションの作成に必要。
  ### contents[:presence_false] -> 登録時に空欄禁止として登録しなかったカラムを格納する。上記と別の処理を行う。
  ### contents[:boolean_group] -> 上記とは別にboolean型のカラムを格納する。バリデーションの処理が異なるため別の配列に格納する。
  ### contents[:references_group] -> references型のカラムを格納する。この配列を参考にアソシエーションに関する記載を行う。
  ### contents[:activehash_group] -> activehash型のカラムを格納する。データ型をintegerに固定し、また専用のアソシエーションを記載する。
  
  ### contents[:ハッシュ] -> 

  # 配列を作成するメソッド
  def make_model_array(model, gemfile)
    contents = make_model_array_template
    model.columns.each do |column|
      if column.data_type_id <= 10
        contents[:presence_true] << column if column.must_exist
        contents[:presence_false] << column if !column.must_exist # && content[:options] != ''
      else
        case column.data_type.type
        when 'boolean'
          contents[:boolean_group] << column
        when 'references'
          contents[:references_group] << column
          # valid_regerences_group << content if content[:options] != ''
        when 'ActiveHash'
          contents[:activehash_group] << column
        end
      end
    end

    puts contents
    contents
  end

  # contents
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

  
end
