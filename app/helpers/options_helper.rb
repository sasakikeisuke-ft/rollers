module OptionsHelper
  # オプションはタイプごとに重複して登録できないようにする。
  # そのため、登録状況から表示非表示が選択されるようにするためのメソッド
  def option_contents_status(options)
    contents = {
      format: true,
      numericality: true,
      uniqueness: true,
      option_count: 0
    }
    options.each do |option|
      case option.option_type.type
      when 'format'
        contents[:format] = false
      when 'numericality'
        contents[:numericality] = false
      when 'uniqueness'
        contents[:uniqueness] = false
      end
    end
    contents
  end
end
