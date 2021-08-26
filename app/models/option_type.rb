class OptionType < ActiveHash::Base
  self.data = [
    { id: 11, type: 'format', info: '漢字かなカナで登録可', code: 'format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: "エラーメッセージ" }',
      message_ja: 'は漢字ひらがなカタカナで入力してください', message_en: ' is invalid. Input full-width characters' },
    { id: 12, type: 'format', info: 'ひらがなのみで登録可', code: 'format: { with: /\A[ぁ-ん]+\z/, message: "エラーメッセージ" }',
      message_ja: 'はひらがなで入力してください', message_en: ' is invalid. Input full-width hiragana characters' },
    { id: 13, type: 'format', info: 'カタカナのみで登録可', code: 'format: { with: /\A[ァ-ヶ]+\z/, message: "エラーメッセージ" }',
      message_ja: 'は全角カタカナで入力してください', message_en: ' is invalid. Input full-width katakana characters' },
    { id: 14, type: 'format', info: '数字のみ限定で登録可', code: 'format: { with: /\A[0-9]+\z/i, message: "エラーメッセージ" }',
      message_ja: 'は数字のみで入力してください',          message_en: 'is invalid. Input harf-width numbers' },
    { id: 15, type: 'format', info: '英字のみ限定で登録可', code: 'format: { with: /\A[a-z]+\z/i, message: "エラーメッセージ" }',
      message_ja: 'は英字のみで入力してください',          message_en: 'is invalid. Input harf-width characters' },
    { id: 16, type: 'format', info: '英字小文字のみ登録可', code: 'format: { with: /\A[a-z]+\z/, message: "エラーメッセージ" }',
      message_ja: 'は小文字の英字のみで入力してください',          message_en: 'is invalid. is invalid. Input lowercase characters' },
    { id: 17, type: 'format', info: '英字大文字のみ登録可', code: 'format: { with: /\A[A-Z]+\z/, message: "エラーメッセージ" }',
      message_ja: 'は大文字の英字のみで入力してください',          message_en: 'is invalid.  Input upper-case characters' },
    { id: 18, type: 'format', info: '英字数字のみで登録可', code: 'format: { with: /\A[0-9a-z]+\z/i, message: "エラーメッセージ" }',
      message_ja: 'は英数字のみで入力してください', message_en: 'is invalid. Input harf-width numbers and characters' },
    # { id: 19, type: 'format', info: '英字数字記号で登録可', code: 'format: { with: /\A[a-zA-Z0-9!-/:-@¥[-`{-~]+\z/, message: "エラーメッセージ" }',
    #   message_ja: 'は英数字および記号のみで入力してください', message_en: 'is invalid.' },
    { id: 20, type: 'format', info: '郵便番号形式で登録可', code: ', format: { with: /\A\d{3}-\d{4}\z/, message: "エラーメッセージ" }',
      message_ja: 'を入力してください。例：123-4567', message_en: ' is invalid. Enter it as follows (e.g. 123-4567)' },

    { id: 21, type: 'numericality', info: '入力のみで登録する', code: 'numericality: { only_integer: true }, message: "エラーメッセージ" }',
      message_ja: 'は半角数字を入力してください', message_en: ' is invalid. Input harf-width numbers' },
    { id: 22, type: 'numericality', info: '上限下限を設定する',
      code: 'numericality: { greater_than_or_equal_to: 入力1, less_than_or_equal_to: 入力2, message: "エラーメッセージ" }',
      message_ja: 'は入力が範囲外です。', message_en: ' is out of setting range' },
    { id: 23, type: 'numericality', info: '上限のみを設定する', code: 'numericality: { less_than_or_equal_to: 入力2, message: "エラーメッセージ" }',
      message_ja: 'は入力が範囲外です。', message_en: ' is out of setting range' },
    { id: 24, type: 'numericality', info: '下限のみを設定する', code: 'numericality: { greater_than_or_equal_to: 入力1, message: "エラーメッセージ" }',
      message_ja: 'は入力が範囲外です。', message_en: ' is out of setting range' },
    { id: 25, type: 'numericality', info: '未選択状態での禁止', code: 'numericality: { other_than: 0, message: "エラーメッセージ" }',
      message_ja: 'を選択してください', message_en: "can't be blank" },

    # lengthオプションに関するコード。今後、追加実装の可能性があるため残しておく。
    # {id: 31, type: 'length', info: '上限下限を設定する', code: 'length: { in: 入力1..入力2 }',
    #   message_ja: '',          message_en: 'is invalid.'},
    # {id: 32, type: 'length', info: '上限のみを設定する', code: 'length: { maximum: 入力2' },
    #   message_ja: '',          message_en: 'is invalid.'},
    # {id: 33, type: 'length', info: '下限のみを設定する', code: 'length: { minimum: 入力1 }',
    #   message_ja: '',          message_en: 'is invalid.'},
    # {id: 34, type: 'length', info: '値の長さを限定する', code: 'length: { is: 入力1 }',
    #   message_ja: '',          message_en: 'is invalid.'},

    { id: 41, type: 'uniqueness', info: '当テーブル内での重複禁止', code: 'uniqueness: { case_sensitive: false }',
      message_ja: 'はすでに存在します', message_en: ' has already been taken' },
    { id: 42, type: 'uniqueness', info: '対象モデル内での重複禁止', code: 'uniqueness: { case_sensitive: false, scope: :入力1_id }',
      message_ja: 'はすでに存在します', message_en: ' has already been taken' },
    { id: 43, type: 'uniqueness', info: '複数のモデルでの重複禁止', code: 'uniqueness: { case_sensitive: false, scope: [:入力1_id, 入力2_id] }',
      message_ja: 'はすでに存在します', message_en: ' has already been taken' }
  ]
  include ActiveHash::Associations
  has_many :options
end
