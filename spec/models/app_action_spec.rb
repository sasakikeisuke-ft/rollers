require 'rails_helper'

RSpec.describe AppAction, type: :model do
  before do
    @app_action = FactoryBot.build(:app_action)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'AppActionモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@app_action).to be_valid
      end
      it 'input1が空欄でも登録できる' do
        @app_action.input1 = ''
        expect(@app_action).to be_valid
      end
      it 'input2が空欄でも登録できる' do
        @app_action.input2 = ''
        expect(@app_action).to be_valid
      end
      it 'input3が空欄でも登録できる' do
        @app_action.input3 = ''
        expect(@app_action).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'targetが空欄だと登録できない' do
        @app_action.target = ''
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("対象モデル名を入力してください")
      end
      it 'app_controllerが紐づけられていないと登録できない' do
        @app_action.app_controller = nil
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("app_controllerを入力してください")
      end
      it 'action_type_idが空欄だと登録できない' do
        @app_action.action_type_id = ''
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("Action type can't be blank")
      end
      it 'action_type_idが未選択だと登録できない' do
        @app_action.action_type_id = 0
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("Action type can't be blank")
      end
      it 'code_type_idが空欄だと登録できない' do
        @app_action.code_type_id = ''
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("Code type can't be blank")
      end
      it 'code_type_idが未選択だと登録できない' do
        @app_action.code_type_id = 0
        @app_action.valid?
        expect(@app_action.errors.full_messages).to include("Code type can't be blank")
      end
    end
  end
end
