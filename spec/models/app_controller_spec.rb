require 'rails_helper'

RSpec.describe AppController, type: :model do
  before do
    @app_controller = FactoryBot.build(:app_controller)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'AppControllerモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@app_controller).to be_valid
      end
      it 'parentが空欄でも登録できる' do
        @app_controller.parent = ''
        expect(@app_controller).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'nameが空欄だと登録できない' do
        @app_controller.name = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("コントローラー名を入力してください")
      end
      it 'nameの重複があり登録できない' do
        @app_controller.save
        another_app_controller = FactoryBot.build(:app_controller, name: @app_controller.name, application: @app_controller.application)
        another_app_controller.valid?
        expect(another_app_controller.errors.full_messages).to include("コントローラー名はすでに存在します")
      end
      it 'index_selectが空欄だと登録できない' do
        @app_controller.index_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Index selectを入力してください")
      end
      it 'new_selectが空欄だと登録できない' do
        @app_controller.new_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("New selectを入力してください")
      end
      it 'create_selectが空欄だと登録できない' do
        @app_controller.create_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Create selectを入力してください")
      end
      it 'edit_selectが空欄だと登録できない' do
        @app_controller.edit_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Edit selectを入力してください")
      end
      it 'update_selectが空欄だと登録できない' do
        @app_controller.update_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Update selectを入力してください")
      end
      it 'destroy_selectが空欄だと登録できない' do
        @app_controller.destroy_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Destroy selectを入力してください")
      end
      it 'show_selectが空欄だと登録できない' do
        @app_controller.show_select = ''
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Show selectを入力してください")
      end
      it 'applicationが紐づけられていないと登録できない' do
        @app_controller.application = nil
        @app_controller.valid?
        expect(@app_controller.errors.full_messages).to include("Applicationを入力してください")
      end
    end
  end
end
