class ActionCode < ActiveHash::Base
  self.data = [

    # データベースへの登録関連
    { id: 1, keyword: '内容', sample: '@model = Model.new' },
    { id: 2, keyword: '内容', sample: '@model = Model.new(model_params)' },
    { id: 3, keyword: '内容', sample: '@model.create(model_params)' },
    { id: 4, keyword: '内容', sample: '@model.update(model_params)' },
    { id: 5, keyword: '内容', sample: 'create向けのレイアウト(固定)' },
    { id: 6, keyword: '内容', sample: 'create向けのレイアウト(編集)' },
    { id: 7, keyword: '内容', sample: 'update向けのレイアウト(固定)' },
    { id: 8, keyword: '内容', sample: 'update向けのレイアウト(編集)' },
    { id: 9, keyword: '内容', sample: '@model.destroy' },

    # 一つのレコードを取得
    { id: 11, keyword: '内容', sample: '@model = Model.find(params[:id])' },
    { id: 12, keyword: '内容', sample: '@model = Model.find_by(model_id: params[:model_id])' },
    { id: 13, keyword: '内容', sample: '@model = Model.find_by(条件式1)' },
    { id: 15, keyword: '内容', sample: '@model = Model.where(条件式1).find_by(条件式2)' },
    { id: 16, keyword: '内容', sample: '@model = Model.where(条件式1, 条件式2).find_by(条件式3)' },
    { id: 17, keyword: '内容', sample: '@model = Model.where(条件式1).where.not(条件式2).find_by(条件式3)' },

    # 複数のレコードを取得
    { id: 21, keyword: '内容', sample: '@models = Model.all' },
    { id: 22, keyword: '内容', sample: '@models = Model.where(条件式1_id: params[条件式_id])' },
    { id: 23, keyword: '内容', sample: '@models = Model.where(条件式1)' },
    { id: 24, keyword: '内容', sample: '@models = Model.where(条件式1: [条件式2])' },
    { id: 25, keyword: '内容', sample: '@models = Model.where(条件式1, 条件式2)' },
    { id: 26, keyword: '内容', sample: '@models = Model.where(条件式1, 条件式2, 条件式3)' },
    { id: 27, keyword: '内容', sample: '@models = Model.where.not(条件式1)' },
    { id: 28, keyword: '内容', sample: '@models = Model.where.not(条件式1: [条件式2])' },
    { id: 29, keyword: '内容', sample: '@models = Model.where.not(条件式1, 条件式2)' },
    { id: 30, keyword: '内容', sample: '@models = Model.where.not(条件式1, 条件式2, 条件式3)' },
    { id: 31, keyword: '内容', sample: '@models = Model.where.(条件式1).where.not(条件式2)' },
    { id: 32, keyword: '内容', sample: '@models = Model.where.(条件式1, 条件式2).where.not(条件式3)' },
    { id: 33, keyword: '内容', sample: '@models = Model.where.(条件式1).where.not(条件式2,条件式3)' },

    # 複数のレコードと関連するテーブルを取得
    { id: 41, keyword: '内容', sample: '@models = Model.includes(:条件式1)' },
    { id: 42, keyword: '内容', sample: '@models = Model.includes(:条件式1).where(条件式2)' },
    { id: 43, keyword: '内容', sample: '@models = Model.includes(:条件式1).where(条件式2, 条件式3)' },
    { id: 44, keyword: '内容', sample: '@models = Model.includes(:条件式1).where.not(条件式2)' },
    { id: 45, keyword: '内容', sample: '@models = Model.includes(:条件式1).where.not(条件式2, 条件式3)' },
    { id: 46, keyword: '内容', sample: '@models = Model.includes(:条件式1).where.(条件式2).where.not(条件式3)' },
    { id: 47, keyword: '内容', sample: '@models = Model.includes(:条件式1, :条件式2)' },
    { id: 48, keyword: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where(条件式3)' },
    { id: 49, keyword: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where.not(条件式3)' },
    { id: 50, keyword: '内容', sample: '@models = Model.includes(:条件式1, :条件式2).where(条件式3)' },
    { id: 51, keyword: '内容', sample: '@models = Model.includes(条件式1: :条件式2).where.not(条件式3)' },

    # 上記以外の取得方法
    { id: 61, keyword: '内容', sample: '@model Model.first' },
    { id: 62, keyword: '内容', sample: '@model Model.first(条件式1)' },
    { id: 63, keyword: '内容', sample: '@model Model.last' },
    { id: 64, keyword: '内容', sample: '@model Model.last(条件式1)' },
    { id: 65, keyword: '内容', sample: '@model Model.take' },
    { id: 66, keyword: '内容', sample: '@model Model.take(条件式1)' },
    { id: 67, keyword: '内容', sample: '@models = group(条件式1)' },
    { id: 68, keyword: '内容', sample: '@models = Model.order(条件式1 ASC)' },
    { id: 69, keyword: '内容', sample: '@models = Model.order(条件式1 DESC)' },
    { id: 79, keyword: '内容', sample: '@models = Model.limit(条件式1)' },
    { id: 71, keyword: '内容', sample: '@models = Model.offset(条件式1)' },
    { id: 72, keyword: '内容', sample: '@models = Model.limit(条件式1).offset(条件式2)' },

    # アソシエーションを利用してレコードを取得
    { id: 81, keyword: '内容', sample: '@A_model = @B_model.A_model' },
    { id: 82, keyword: '内容', sample: '@A_model = @B_models.A_model' },
    { id: 83, keyword: '内容', sample: '@A_models = @B_model.A_models' },
    { id: 84, keyword: '内容', sample: '@A_models = @B_model.A_models' },

    # redirect_toの設定
    { id: 91, keyword: '内容', sample: 'redirect_to root_path' },
    { id: 92, keyword: '内容', sample: 'redirect_to 条件式1_path' },
    { id: 93, keyword: '内容', sample: 'redirect_to 条件式1_path(params[:id])' },
    { id: 94, keyword: '内容', sample: 'redirect_to 条件式1_path(params[条件式2_id])' },
    { id: 95, keyword: '内容', sample: 'redirect_to 条件式1_path(条件式2_id: params[条件式2_id])' },
    { id: 96, keyword: '内容', sample: 'render 条件式1' },

    # オリジナルアクションの雛形設定
    { id: 98, keyword: '内容', sample: 'collection' },
    { id: 99, keyword: '内容', sample: 'member' }
  ]
  include ActiveHash::Associations
  has_many :app_actions
end
