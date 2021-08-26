require 'rails_helper'

RSpec.describe Column, type: :model do
  before do
    @column = FactoryBot.build(:column)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Columnモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@column).to be_valid
      end
      it 'name_jaが空欄でも登録できる' do
        @column.name_ja = ''
        expect(@column).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'nameが空欄だと登録できない' do
        @column.name = ''
        @column.valid?
        expect(@column.errors.full_messages).to include('カラム名を入力してください')
      end
      it 'nameの重複があり登録できない' do
        @column.save
        another_column = FactoryBot.build(:column, name: @column.name, model: @column.model)
        another_column.valid?
        expect(another_column.errors.full_messages).to include('カラム名はすでに存在します')
      end
      it 'data_type_idが空欄だと登録できない' do
        @column.data_type_id = ''
        @column.valid?
        expect(@column.errors.full_messages).to include('Data typeを入力してください')
      end
      it 'modelが紐づけられていないと登録できない' do
        @column.model = nil
        @column.valid?
        expect(@column.errors.full_messages).to include('Modelを入力してください')
      end
      it 'applicationが紐づけられていないと登録できない' do
        @column.application = nil
        @column.valid?
        expect(@column.errors.full_messages).to include('Applicationを入力してください')
      end
      it 'data_type_idが未選択だと登録できない' do
        @column.data_type_id = 0
        @column.valid?
        expect(@column.errors.full_messages).to include('Data typeを選択してください')
      end
    end
  end
end
