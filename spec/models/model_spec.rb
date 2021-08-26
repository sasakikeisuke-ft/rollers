require 'rails_helper'

RSpec.describe Model, type: :model do
  before do
    @model = FactoryBot.build(:model)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Modelモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@model).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'nameが空欄だと登録できない' do
        @model.name = ''
        @model.valid?
        expect(@model.errors.full_messages).to include("モデル名を入力してください")
      end
      it 'nameの重複があり登録できない' do
        @model.save
        another_model = FactoryBot.build(:model, name: @model.name, application: @model.application)
        another_model.valid?
        expect(another_model.errors.full_messages).to include("モデル名はすでに存在します")
      end
      it 'model_type_idが空欄だと登録できない' do
        @model.model_type_id = ''
        @model.valid?
        expect(@model.errors.full_messages).to include("Model typeを入力してください")
      end
      it 'applicationが紐づけられていないと登録できない' do
        @model.application = nil
        @model.valid?
        expect(@model.errors.full_messages).to include("Applicationを入力してください")
      end
      it 'model_type_idが未選択だと登録できない' do
        @model.model_type_id = 0
        @model.valid?
        expect(@model.errors.full_messages).to include("Model typeを選択してください")
      end
    end
  end
end
