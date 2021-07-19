require 'rails_helper'
RSpec.describe Controller, type: :model do
  before do
    @controller = FactoryBot.build(:controller)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Controllerモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@controller).to be_valid
      end
      it 'parentが空欄でも登録できる' do
        @controller.parent = ''
        expect(@controller).to be_valid
      end
      it 'targetが空欄でも登録できる' do
        @controller.target = ''
        expect(@controller).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'nameが空欄だと登録できない' do
        @controller.name = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('コントローラー名を入力してください')
      end
      it 'index_selectが空欄だと登録できない' do
        @controller.index_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('indexを入力してください')
      end
      it 'new_selectが空欄だと登録できない' do
        @controller.new_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('newを入力してください')
      end
      it 'create_selectが空欄だと登録できない' do
        @controller.create_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('createを入力してください')
      end
      it 'edit_selectが空欄だと登録できない' do
        @controller.edit_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('editを入力してください')
      end
      it 'update_selectが空欄だと登録できない' do
        @controller.update_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('updateを入力してください')
      end
      it 'destroy_selectが空欄だと登録できない' do
        @controller.destroy_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('destroyを入力してください')
      end
      it 'show_selectが空欄だと登録できない' do
        @controller.show_select = ''
        @controller.valid?
        expect(@controller.errors.full_messages).to include('showを入力してください')
      end
      it 'applicationが紐づけられていないと登録できない' do
        @controller.application = nil
        @controller.valid?
        expect(@controller.errors.full_messages).to include('applicationを入力してください')
      end
      it 'nameの重複があり登録できない' do
        @controller.save
        another_controller = FactoryBot.build(:controller, name: @controller.name, application_id: @controller.application_id)
        another_controller.valid?
        expect(another_controller.errors.full_messages).to include('コントローラー名はすでに存在します')
      end
    end
  end
end
