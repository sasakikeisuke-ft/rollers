module GemfilesHelper
  
  # 対象モデルの中で最も長いカラム名の文字数を返すメソッド
  def the_longest(longest ,model)
    longest = 18 if model.model_type_id == 5  
    model.columns.each do |column| 
      long = column.name.length if column.data_type_id != 13 
      long = column.name.length + 3 if column.data_type_id == 13 
      longest = long if long > longest 
    end 
    return longest
  end

  # 指定した回数だけ - を挿入するメソッド
  def insert_bar(roops)
    bar = ''
    roops.times do
    bar += '-'
    end
    return raw(bar)
  end

  # 上記の the_longest の一部変更したメソッド
  # モデルではなくアプリケーション全体から、最も長いカラム名の文字数を返す。
  def longest_of_all(columns)
    longest = 6 if model.model_type_id != 5  
    longest = 18 if model.model_type_id == 5  
    columns.each do |column| 
      long = column.name.length if column.data_type_id != 13 
      long = column.name.length + 3 if column.data_type_id == 13 
      longest = long if long > longest   
    end
  end
    
  def make_japanise_html(models)
    html = ''
    models.each do |model|
      html += "#{insert_space(6)}#{model.name}:"
      html += '<br>'
      model.columns.each do |column|
        if column.name_ja != ''
          html += "#{insert_space(8)}#{column.name}: #{column.name_ja}"
        else
          html += "#{insert_space(8)}#{column.name}: #{column.name}"
        end
        html += '<br>'
      end
    end
    return html
  end

end
