class DataType < ActiveHash::Base
  self.data = [
    {id: 0, type: '----------'},
    {id: 1, type: 'string    '},
    {id: 2, type: 'text      '},
    {id: 3, type: 'integer   '},
    {id: 4, type: 'float     '},
    {id: 5, type: 'decimal   '},
    {id: 6, type: 'date      '},
    {id: 7, type: 'time      '},
    {id: 8, type: 'datetime  '},
    {id: 11, type: 'boolean   '},
    {id: 12, type: 'references'}
    
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