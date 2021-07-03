class ModelType < ActiveHash::Base
  self.data = [
    {id: 1, name: '通常モデル'},
    {id: 2, name: 'ActiveHash'},
    # {id: 3, name: 'Formオブジェクト'},
    # {id: 4, name: '中間テーブル'}
    {id: 5, name: 'devise'},
              ]
  include ActiveHash::Associations
  has_many :models
end