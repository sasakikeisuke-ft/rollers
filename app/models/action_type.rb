class ActionType < ActiveHash::Base
  self.data = [
    { id:  0, original: '', name: '-----'   },
    { id:  1, original: 'collection', name: 'index' },
    { id:  2, original: 'member', name: 'new' },
    { id:  3, original: '', name: 'create'  },
    { id:  4, original: '', name: 'edit'    },
    { id:  5, original: '', name: 'update'  },
    { id:  6, original: '', name: 'destroy' },
    { id:  7, original: '', name: 'show'    },
    { id:  8, original: '', name: '共通1'   },
    { id:  9, original: '', name: '共通2'   },
    { id: 10, original: '', name: 'search' }
  ]
  include ActiveHash::Associations
  has_many :actions
end
