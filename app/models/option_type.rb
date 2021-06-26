class OptionType < ActiveHash::Base
  self.data = [
    # code_jaとcode_enには重複が多い。
    # いずれはcodeとmessage_ja/message_enに分けたい。
    # そうすると、Rspecにおける表示にもmessage_jaなどと流用可能となる。
    {id: 11, type: 'format', display: '漢字かなカナで登録可', code: ', format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: ', message_ja: '"は漢字全角ひらがなカタカナで入力してください"', message_en: '"is invalid. Input full-width characters"'},
    {id: 12, type: 'format', display: 'ひらがなのみで登録可', code: ', format: { with: /\A[ぁ-ん]+\z/, message: }',            message_ja: '"は全角ひらがなで入力してください"',           message_en: '"is invalid. Input full-width hiragana characters"'},
    {id: 13, type: 'format', display: 'カタカナのみで登録可', code: ', format: { with: /\A[ァ-ヶ]+\z/, message: }',            message_ja: '"は全角カタカナで入力してください"',           message_en: '"is invalid. Input full-width katakana characters"'},
    {id: 14, type: 'format', display: '郵便番号形式で登録可', code: ', format: { with: /\A\d{3}-\d{4}\z/, message: }',            message_ja: '"を入力してください。例：123-4567"',          message_en: '"is invalid. Enter it as follows (e.g. 123-4567)"'},
    # {id: 15, type: 'format', display: '英数字混合パスワード', code: '',            message_ja: '""',          message_en: '"is invalid."'},


    {id: 21, type: 'numericality', display: '数値のみで登録する', code: ', numericality: true, message: ',           message_ja: '"は半角数字を入力してください"', message_en:'"is invalid. Input harf-width numbers"'},
    {id: 22, type: 'numericality', display: '上限下限を設定する', code: ', numericality: {greater_than_or_equal_to: 数値, less_than_or_equal_to: 数値, message: ', message_ja: '"は数値が範囲外です。"', message_en: '"is out of setting range"'},
    {id: 23, type: 'numericality', display: '上限のみを設定する', code: ', numericality: {less_than_or_equal_to: 数値, message: ', message_ja: '"は数値が範囲外です。"', message_en: '"is out of setting range"'},
    {id: 24, type: 'numericality', display: '下限のみを設定する', code: ', numericality: {greater_than_or_equal_to: 数値, message: ', message_ja: '"は数値が範囲外です。"', message_en: '"is out of setting range"'},
    {id: 25, type: 'numericality', display: '未選択状態での禁止', code: ', numericality: { other_than: 0, message: ', message_ja: '"を選択してください"', message_en: `"can't be blank"`},
    
    # {id: 31, type: 'length', display: 'length'},
    {id: 41, type: 'uniqueness', display: '当テーブル内での重複禁止', code: ', uniqueness: true'}
    {id: 42, type: 'uniqueness', display: '対象モデル内での重複禁止', code: ', uniqueness: { scope: :model名_id }'}
    {id: 43, type: 'uniqueness', display: '複数のモデルでの重複禁止', code: ', uniqueness: { scope: [:model名_id, :model名_id] }'}
              ]
  include ActiveHash::Associations
  has_many :options
end