require 'rails_helper'

RSpec.describe Option, type: :model do
  before do
    @option = FactoryBot.build(:option)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Optionモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@option).to be_valid
      end
      it 'input1が空欄でも登録できる' do
        @option.input1 = ''
        expect(@option).to be_valid
      end
      it 'input2が空欄でも登録できる' do
        @option.input2 = ''
        expect(@option).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'option_type_idが空欄だと登録できない' do
        @option.option_type_id = ''
        @option.valid?
        expect(@option.errors.full_messages).to include("Option typeを入力してください")
      end
      it 'columnが紐づけられていないと登録できない' do
        @option.column = nil
        @option.valid?
        expect(@option.errors.full_messages).to include("Columnを入力してください")
      end
      it 'option_type_idが未選択だと登録できない' do
        @option.option_type_id = 0
        @option.valid?
        expect(@option.errors.full_messages).to include("Option typeを選択してください")
      end
    end
  end
end
