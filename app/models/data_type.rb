class DataType < ActiveHash::Base
  self.data = [
    { id:  0, type: '----------', info: '未選択', space: 0 },
    { id:  1, type: 'string', info: '文字列(短文)', space: 4 },
    { id:  2, type: 'text', info: '文字列(長文)', space: 6 },
    { id:  3, type: 'integer', info: '整数型', space: 3 },
    { id:  4, type: 'float', info: '浮動小数点数', space: 5 },
    { id:  5, type: 'decimal', info: '固定長整数型', space: 3 },
    { id:  6, type: 'date', info: '日付', space: 6 },
    { id:  7, type: 'time', info: '時刻', space: 6 },
    { id:  8, type: 'datetime', info: '日付と時刻', space: 2 },
    { id: 11, type: 'boolean', info: '真偽値', space: 3 },
    { id: 12, type: 'references', info: '外部キーを参照', space: 0 },
    { id: 13, type: 'ActiveHash', info: '', space: 0 },
    { id: 15, type: 'ActiveHashの要素', info: '', space: 0 },
    { id: 16, type: 'Formオブジェクトの対象モデル', info: '', space: 0 }
  ]
  include ActiveHash::Associations
  has_many :columns
end
