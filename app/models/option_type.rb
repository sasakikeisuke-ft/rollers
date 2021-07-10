class OptionType < ActiveHash::Base
  self.data = [
    {id: 11, type: 'format', info: '漢字かなカナで登録可', code: ', format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: ', message_ja: 'は漢字ひらがなカタカナで入力してください', message_en: ' is invalid. Input full-width characters'},
    {id: 12, type: 'format', info: 'ひらがなのみで登録可', code: ', format: { with: /\A[ぁ-ん]+\z/, message: ',            message_ja: 'はひらがなで入力してください',           message_en: ' is invalid. Input full-width hiragana characters'},
    {id: 13, type: 'format', info: 'カタカナのみで登録可', code: ', format: { with: /\A[ァ-ヶ]+\z/, message: ',            message_ja: 'は全角カタカナで入力してください',           message_en: ' is invalid. Input full-width katakana characters'},
    {id: 14, type: 'format', info: '郵便番号形式で登録可', code: ', format: { with: /\A\d{3}-\d{4}\z/, message: ',            message_ja: 'を入力してください。例：123-4567',          message_en: ' is invalid. Enter it as follows (e.g. 123-4567)'},
    # {id: 15, type: 'format', info: '数字のみ限定で登録可', code: ', format: { with: /\A[0-9]+\z/i, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英字のみ限定で登録可', code: ', format: { with: /\A[a-z]+\z/i, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英字小文字のみ登録可', code: ', format: { with: /\A[a-z]+\z/, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英字大文字のみ登録可', code: ', format: { with: /\A[A-Z]+\z/, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英字数字のみで登録可', code: ', format: { with: /\A[0-9a-z]+\z/i, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英字数字記号で登録可', code: ', format: { with: /\A[ぁ-ん]+\z/, message: ',            message_ja: '""',          message_en: 'is invalid.'},
    # {id: 15, type: 'format', info: '英数字混合パスワード', code: '',            message_ja: '""',          message_en: 'is invalid.'},
    

    {id: 21, type: 'numericality', info: '数値のみで登録する', code: 'numericality: { only_integer: true }, message: ',           message_ja: 'は半角数字を入力してください', message_en:' is invalid. Input harf-width numbers'},
    {id: 22, type: 'numericality', info: '上限下限を設定する', code: 'numericality: { greater_than_or_equal_to: 数値, less_than_or_equal_to: 数値, message: ', message_ja: 'は数値が範囲外です。', message_en: ' is out of setting range'},
    {id: 23, type: 'numericality', info: '上限のみを設定する', code: 'numericality: { less_than_or_equal_to: 数値, message: ', message_ja: 'は数値が範囲外です。', message_en: ' is out of setting range'},
    {id: 24, type: 'numericality', info: '下限のみを設定する', code: 'numericality: { greater_than_or_equal_to: 数値, message: ', message_ja: 'は数値が範囲外です。', message_en: ' is out of setting range'},
    {id: 25, type: 'numericality', info: '未選択状態での禁止', code: 'numericality: { other_than: 0, message: ', message_ja: 'を選択してください', message_en: "can't be blank"},
    
    # {id: 31, type: 'length', info: '上限下限を設定する', code: ', length: { in: ',      message_ja: '',          message_en: 'is invalid.'},
    # {id: 32, type: 'length', info: '上限のみを設定する', code: ', length: { maximum: ', message_ja: '',          message_en: 'is invalid.'},
    # {id: 33, type: 'length', info: '下限のみを設定する', code: ', length: { minimum: ', message_ja: '',          message_en: 'is invalid.'},
    # {id: 34, type: 'length', info: '値の長さを限定する', code: ', length: { is: ',      message_ja: '',          message_en: 'is invalid.'},
    
    {id: 41, type: 'uniqueness', info: '当テーブル内での重複禁止', code: ', uniqueness: true', message_ja: 'はすでに存在します', message_en: ' has already been taken'},
    {id: 42, type: 'uniqueness', info: '対象モデル内での重複禁止', code: ', uniqueness: { scope: :', message_ja: 'はすでに存在します', message_en: ' has already been taken'},
    {id: 43, type: 'uniqueness', info: '複数のモデルでの重複禁止', code: ', uniqueness: { scope: [:', message_ja: 'はすでに存在します', message_en: ' has already been taken'}
    # {id: 42, type: 'uniqueness', info: '対象モデル内での重複禁止', code: ', uniqueness: { scope: :model名_id }', message_ja: 'はすでに存在します', message_en: ' has already been taken'},
    # {id: 43, type: 'uniqueness', info: '複数のモデルでの重複禁止', code: ', uniqueness: { scope: [:model名_id, :model名_id] }', message_ja: 'はすでに存在します', message_en: ' has already been taken'}
              ]
  include ActiveHash::Associations
  has_many :options
end