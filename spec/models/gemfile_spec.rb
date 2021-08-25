require 'rails_helper'

RSpec.describe Gemfile, type: :model do
  before do
    @gemfile = FactoryBot.build(:gemfile)
    sleep 0.1 # エラーを防ぐために休止時間を入れています。不要なら削除してください。
  end

  describe 'Gemfileモデルの登録機能' do
    context '入力内容が適切であれば登録できる' do
      it '入力内容が全て適切であれば登録できる' do
        expect(@gemfile).to be_valid
      end
    end

    context '不適切な内容があり登録できない' do
      it 'applicationが紐づけられていないと登録できない' do
        @gemfile.application = nil
        @gemfile.valid?
        expect(@gemfile.errors.full_messages).to include("Applicationを入力してください")
      end
    end
  end
end
