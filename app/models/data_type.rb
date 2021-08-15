class DataType < ActiveHash::Base
  self.data = [
    { id:  0, type: '----------', space: 0 },
    { id:  1, type: 'string'    , space: 3 },
    { id:  2, type: 'text'      , space: 5 },
    { id:  3, type: 'integer'   , space: 2 },
    { id:  4, type: 'float'     , space: 5 },
    { id:  5, type: 'decimal'   , space: 2 },
    { id:  6, type: 'date'      , space: 5 },
    { id:  7, type: 'time'      , space: 5 },
    { id:  8, type: 'datetime'  , space: 1 },
    { id: 11, type: 'boolean'   , space: 2 },
    { id: 12, type: 'references', space: 0 },
    { id: 13, type: 'ActiveHash', space: 0 },
    { id: 15, type: 'ActiveHashの要素', space: 0 },
    { id: 16, type: 'Formオブジェクトの対象モデル', space: 0 }
  ]
  include ActiveHash::Associations
  has_many :columns
end
