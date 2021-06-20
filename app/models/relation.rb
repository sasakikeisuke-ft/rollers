class Relation < ActiveHash::Base
  self.data = [
    {id: 0, to_right: '--',    right_code: '',           to_left: '--',      left_code: ''},
    {id: 1, to_right: '一対多', right_code: 'has_many :', to_left: '多対一', left_code: 'belongs_to :'},
    {id: 2, to_right: '多対一', right_code: 'belongs_to', to_left: '一対多', left_code: 'has_many :'},
    {id: 3, to_right: '親対子', right_code: 'has_one',    to_left: '子対親', left_code: 'belongs_to :'},
    {id: 4, to_right: '子対親', right_code: 'belongs_to', to_left: '親対子', left_code: 'has_one :'}
              ]
  include ActiveHash::Associations
  has_many :associations
end