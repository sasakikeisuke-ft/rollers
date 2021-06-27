class DataType < ActiveHash::Base
  self.data = [
    {id:  0, type: '----------', space: 0},
    {id:  1, type: 'string    ', space: 3},
    {id:  2, type: 'text      ', space: 5},
    {id:  3, type: 'integer   ', space: 2},
    {id:  4, type: 'float     ', space: 5},
    {id:  5, type: 'decimal   ', space: 2},
    {id:  6, type: 'date      ', space: 5},
    {id:  7, type: 'time      ', space: 5},
    {id:  8, type: 'datetime  ', space: 1},
    {id: 11, type: 'boolean   ', space: 2},
    {id: 12, type: 'references', space: 0},
    {id: 13, type: 'ActiveHash', space: 0}
    
    
    # 上記は新バージョン。データ型のみ選択式にした。
    # 以下は旧バージョン。今後削除予定
    # {id: 0, type: '--', option: ''},

    # integer
    # {id: 11, type: 'integer', option: ''},
    # postal_code
    # {id: 12, type: 'integer', option: ", length: { in: 10..11 }, format: { with: /\A[0-9]+\z/, message: 'is invalid. Input only number' }"},
    # price
    # {id: 13, type: 'integer', option: ", format: {with: /\A[0-9]+\z/, message: 'is invalid. Input half-width characters'}"},

    # {id: 21, type: 'string', option: ''},
    # postal_code
    # {id: 22, type: 'string', option: ", format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' }"},

    # {id: 31, type: 'text', option: ''},

    # {id: 41, type: 'date', option: ''},

    # {id: 51, type: 'time', option: ''},

    # {id: 61, type: 'datetime', option: ''},
    

    # {id: 101, type: 'boolean', option: ''}, # integerはpresence: true を適応できないため別
    # {id: 102, type: 'integer', option: ''} # ActiveHash用
    
              ]
  include ActiveHash::Associations
  has_many :columns
end