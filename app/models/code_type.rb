class CodeType < ActiveHash::Base
  self.data = [

    # インスタンスを作成
    { id: 1, info: '内容', sample: '@model = Model.new' },
    # { id: 2, info: '内容', sample: '@model.new(model_params)' },
    # { id: 3, info: '内容', sample: '@model.create' },
    # { id: 3, info: '内容', sample: '' },
    # { id: 3, info: '内容', sample: '@model.update' },
    # { id: 4, info: '内容', sample: '内容' },

    # 一つのレコードを取得
    { id: 11, info: '内容', sample: '@model = Model.find(params[:id])' },
    { id: 12, info: '内容', sample: '@model = Model.find_by(model_id: params[:model_id])' },
    { id: 13, info: '内容', sample: '@model = Model.find_by(条件式1)' },
    { id: 15, info: '内容', sample: '@model = Model.where(条件式1).find_by(条件式2)' },
    { id: 16, info: '内容', sample: '@model = Model.where(条件式1, 条件式2).find_by(条件式3)' },
    { id: 17, info: '内容', sample: '@model = Model.where(条件式1).where.not(条件式2).find_by(条件式3)' },

    # 複数のレコードを取得
    { id: 21, info: '内容', sample: '@models = Model.all' },
    { id: 22, info: '内容', sample: '@models = Model.where(条件式1)' },
    { id: 23, info: '内容', sample: '@models = Model.where(条件式1, 条件式2)' },
    { id: 24, info: '内容', sample: '@models = Model.where(条件式1, 条件式2, 条件式3)' },
    { id: 25, info: '内容', sample: '@models = Model.where.not(条件式1)' },
    { id: 26, info: '内容', sample: '@models = Model.where.not(条件式1, 条件式2)' },
    { id: 27, info: '内容', sample: '@models = Model.where.not(条件式1, 条件式2, 条件式3)' },
    { id: 28, info: '内容', sample: '@models = Model.where.(条件式1).where.not(条件式2)' },
    { id: 29, info: '内容', sample: '@models = Model.where.(条件式1, 条件式2).where.not(条件式3)' },
    { id: 30, info: '内容', sample: '@models = Model.where.(条件式1).where.not(条件式2,条件式3)' },

    # 複数のレコードと関連するテーブルを取得
    { id: 41, info: '内容', sample: '@models = Model.includes(:条件式1)' },
    { id: 42, info: '内容', sample: '@models = Model.includes(:条件式1).where(条件式2)' },
    { id: 43, info: '内容', sample: '@models = Model.includes(:条件式1).where(条件式2, 条件式3)' },
    { id: 44, info: '内容', sample: '@models = Model.includes(:条件式1).where.not(条件式2)' },
    { id: 45, info: '内容', sample: '@models = Model.includes(:条件式1).where.not(条件式2, 条件式3)' },
    { id: 46, info: '内容', sample: '@models = Model.includes(:条件式1).where.(条件式2).where.not(条件式3)' },
    { id: 47, info: '内容', sample: '@models = Model.includes(:条件式1, :条件式2)' },
    { id: 48, info: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where(条件式3)' },
    { id: 49, info: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where.not(条件式3)' },
    { id: 50, info: '内容', sample: '@models = Model.includes(:条件式1, :条件式2).where(条件式3)' },
    { id: 51, info: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where.not(条件式3)' },

    # 上記以外の取得方法
    { id: 61, info: '内容', sample: '@model Model.first' },
    { id: 62, info: '内容', sample: '@model Model.first(条件式1)' },
    { id: 63, info: '内容', sample: '@model Model.last' },
    { id: 64, info: '内容', sample: '@model Model.last(条件式1)' },
    { id: 65, info: '内容', sample: '@model Model.take' },
    { id: 66, info: '内容', sample: '@model Model.take(条件式1)' },
    { id: 67, info: '内容', sample: '@models = group(条件式1)' },
    { id: 68, info: '内容', sample: '@models = Model.order(条件式1 ASC)' },
    { id: 69, info: '内容', sample: '@models = Model.order(条件式1 DESC)' },
    { id: 79, info: '内容', sample: '@models = Model.limit(条件式1)' },
    { id: 71, info: '内容', sample: '@models = Model.offset(条件式1)' },
    { id: 72, info: '内容', sample: '@models = Model.limit(条件式1).offset(条件式2)' },

    # アソシエーションを利用してレコードを取得
    { id: 81, info: '内容', sample: '@A_model = @B_model.A_model' },
    { id: 82, info: '内容', sample: '@A_model = @B_models.A_model' },
    { id: 83, info: '内容', sample: '@A_models = @B_model.A_models' },
    { id: 84, info: '内容', sample: '@A_models = @B_model.A_models' },

    { id: 91, info: '内容', sample: 'collection' },
    { id: 92, info: '内容', sample: 'member' }
  ]
  include ActiveHash::Associations
  has_many :actions
end
