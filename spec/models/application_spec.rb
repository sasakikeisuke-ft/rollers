require 'rails_helper'

RSpec.describe Application, type: :model do
  before do
    @application = FactoryBot.build(:application)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Applicationモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@application).to be_valid
      end
      it 'descriptionが空欄でも登録できる' do
        @application.description = ''
        expect(@application).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'nameが空欄だと登録できない' do
        @application.name = ''
        @application.valid?
        expect(@application.errors.full_messages).to include('アプリケーション名を入力してください')
      end
      it 'userが紐づけられていないと登録できない' do
        @application.user = nil
        @application.valid?
        expect(@application.errors.full_messages).to include('userを入力してください')
      end
    end
  end
end
