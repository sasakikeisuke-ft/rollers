class Relation < ActiveHash::Base
  self.data = [
    {id: 0, name: '--', code: ''},
    {id: 1, name: '一対多', code: 'has_many :'},
    {id: 2, name: '多対一', code: 'belongs_to :'},
    {id: 3, name: '親対子', code: 'has_one :'},
    {id: 4, name: '子対親', code: 'belongs_to :'}
              ]
  include ActiveHash::Associations
  has_many :associations
end