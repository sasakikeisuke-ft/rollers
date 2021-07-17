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
end
