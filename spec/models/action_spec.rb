require 'rails_helper'

RSpec.describe Action, type: :model do
  before do
    @action = FactoryBot.build(:action)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Actionモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@action).to be_valid
      end
      it 'input1が空欄でも登録できる' do
        @action.input1 = ''
        expect(@action).to be_valid
      end
      it 'input2が空欄でも登録できる' do
        @action.input2 = ''
        expect(@action).to be_valid
      end
      it 'input3が空欄でも登録できる' do
        @action.input3 = ''
        expect(@action).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'targetが空欄だと登録できない' do
        @action.target = ''
        @action.valid?
        expect(@action.errors.full_messages).to include('対象モデル名を入力してください')
      end
      it 'app_controllerが紐づけられていないと登録できない' do
        @action.app_controller = nil
        @action.valid?
        expect(@action.errors.full_messages).to include('app_controllerを入力してください')
      end
      it 'action_typeが空欄だと登録できない' do
        @action.action_type_id = ''
        @action.valid?
        expect(@action.errors.full_messages).to include("Action type can't be blank")
      end
      it 'action_typeが未選択だと登録できない' do
        @action.action_type_id = 0
        @action.valid?
        expect(@action.errors.full_messages).to include("Action type can't be blank")
      end
      it 'aciton_codeが空欄だと登録できない' do
        @action.aciton_code_id = ''
        @action.valid?
        expect(@action.errors.full_messages).to include("Aciton code can't be blank")
      end
      it 'aciton_codeが未選択だと登録できない' do
        @action.aciton_code_id = 0
        @action.valid?
        expect(@action.errors.full_messages).to include("Aciton code can't be blank")
      end
    end
  end
end
