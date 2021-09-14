# Rollers

# README

# アプリケーション概要
RollersはRubyのフレームワークであるRailsの作成を補助することを目的に作成したアプリケーションです。
アプリケーション名に始まり、モデル名からカラム名とデータ型、カラムに付属させるオプションなどを登録することで、対応するコードを自動的に作成します。

# デモ

## トップページ
![トップページ画像](https://i.gyazo.com/18506c0254fa4e90e0576819f8721301.jpg)

## アプリケーション登録画面
![アプリケーション登録画面](https://i.gyazo.com/369ae3daa54cd7ddb9634d06e5062c11.png)

## モデル関連の登録画面
![モデル登録画面](https://i.gyazo.com/45292ca16825a0901af560357f7638b3.png)<br>
![カラム登録画面](https://i.gyazo.com/65706823986006cb2e204360eb1202c7.png)

## コントローラー関連の登録画面
![コントローラー登録画面](https://i.gyazo.com/7b0d1f35a6340a5b31587b62c65d9348.png)<br>
![アクション登録画面](https://i.gyazo.com/7fc13c11f065ec62375fe5c39d0927d2.png)

## 操作指示画面
![操作指示及びコード表示](https://i.gyazo.com/21664ca82cab86455ecb81a1840e030d.png)

## 自動生成されたREADMEと、そのコピー＆ペーストした場合
![READMEのコピー＆ペースト](https://i.gyazo.com/d895cd83211464a5664a5eb1fdb39f28.gif)

## 自動作成されたモデル関連ファイルのコード
![マイグレーションファイル](https://i.gyazo.com/8f11622c9e7b65940bb275310a9729c7.png)<br>
![モデルファイル](https://i.gyazo.com/a30a6d7478f5919f78faf195efa89f22.png)

## 自動作成されたコントローラーファイルのコード
![コントローラー](https://i.gyazo.com/8d551f2b4c7186dd6062787334792f44.png)


## 🌐 URL
https://rollers-35363.herokuapp.com<br>
ID: admin<br>
Password: 2222<br>

### テスト用アカウント
メールアドレス: sample@sample<br>
Password: a1234567<br>


## 利用方法
- ユーザーを新規登録する。
- アプリケーションの名称と説明文を登録する
- 選択肢から使用するGemを選択する
- モデル、カラム、オプションを登録する
- コントローラー、アクションを登録する
- コード表示画面からターミナル操作内容を確認、実施する
- コード表示画面からファイル記載内容を確認しコピー＆ペーストを行う

## 目指した課題解決
新規アプリケーション開発を円滑にすること。
記入する内容の抜けやタイプミスを防ぐこと。
開発を開始する前にコード内容を確認できるようにすること。


## 作成動機
自分がオンラインスクールに通いRubyやRailsといったプログラミングを学ぶ中で、細々としたタイプミスを多く経験しました。
タイプミスを起因とするエラーが生じたとき、その原因検索に非常に時間を取られてしまうことも数多くありました。
自分の知識不足に起因するミスであれば学習による改善が期待できますが、タイプミスといったヒューマンエラーを減らすのは難しいと考えております。
一方で、学習を進めていくうちに記載していくコードには一定の共通部分や繰り返し操作があることに気がつきました。
ここから「コードを自動生成すればタイプミスは起きないのではないか」と思い至り、本アプリケーションの制作に着手しました。
皆様の円滑なアプリケーション開発の助力になれれば幸いです。


## 力を入れた箇所

### 自動作成されたコードはコピー＆ペーストが可能
本アプリケーションの最大の目的は、Railsに関するコードを自動で作成することで、ユーザーの操作及びタイプミスを減らすことにあります。
そのことから、インデント＝スペースの数や改行がコードの通りに表示されることを心がけました。
これにより、表示されているコードをコピー＆ペーストしても、インデントが崩れないようにしました。

### パフォーマンスの向上
本アプリケーションはテーブルの数が多く、また登録内容からレコードの数が多くなってしまうという特徴があります。
そのためDBへアクセスする回数が多くなれば、ひどくパフォーマンスが低下してしまうことが予想されました。
以上からパフォーマンス低下を防ぐため、
- N＋1問題の解消
- if文より処理速度が早いcase文を多用する
- DBへのアクセス回数を減らすため、一度のアクセスにより情報を処理する
上記に注意し実装しました。


## 現在の課題

### UIの工夫不足
本アプリケーションはコード表示機能を最大の目標として作成してきましたが、フロントエンドに関する実装はあまり進んでおりません。
ユーザーの期待するコードを表示するには事前にアプリケーション内容を保存する必要がありますが、登録のしにくさは拭いきれていません。
今後Bootstrapを導入すればある程度の改善が見込めますが、ユーザーの操作性を向上するにはまだまだ研究が必要だと考えます。

### 可読性の問題
力を入れた箇所にも記述しましたが、本アプリケーションはテーブル数、レコード数が多くなるためDBへのアクセス回数を減らすように心がけました。
しかしその結果、ヘルパーメソッドやサービスクラスの肥大化が見られております。
リファクタリングを行うなど可読性には注意を払いつつ進めてきましたが、より可読性の高いコードを記載できるよう学習の継続が必要です。


# テーブル設計

## usersテーブル

| column             | Type       | Options                   |
| ------------------ | ---------- | ------------------------- |
| nickname           | string     | null: false               |
| email              | string     | null: false, unique: true |
| encrypted_password | string     | null: false               |

### Association

- has_many :applications

## applicationsテーブル

| column      | Type       | Options                   |
| ----------- | ---------- | ------------------------- |
| name        | string     | null: false               |
| description | text       |                           |
| user        | references | foreign_key: true         |

### Association

- belongs_to :user
- has_many :models
- has_many :columns
- has_many :app_controllers
- has_many :app_actions
- has_one :gemfile

## gemfilesテーブル

| column       | Type       | Options                   |
| ------------ | ---------- | ------------------------- |
| devise       | boolean    | null: false               |
| pry_rails    | boolean    | null: false               |
| image_magick | boolean    | null: false               |
| active_hash  | boolean    | null: false               |
| rails_i18n   | boolean    | null: false               |
| ransack      | boolean    | null: false               |
| rubocop      | boolean    | null: false               |
| rspec        | boolean    | null: false               |
| payjp        | boolean    | null: false               |
| s3           | boolean    | null: false               |
| application  | references | foreign_key: true         |

### Association

- belongs_to :application

## modelsテーブル

| column         | Type       | Options                   |
| -------------- | ---------- | ------------------------- |
| name           | string     | null: false               |
| not_only       | boolean    | null: false               |
| attached_image | boolean    | null: false               |
| model_type_id  | integer    | null: false               |
| application    | references | foreign_key: true         |

### Association

- belongs_to :application
- has_many :columns

## columnsテーブル

| column       | Type       | Options                   |
| ------------ | ---------- | ------------------------- |
| name         | string     | null: false               |
| name_ja      | string     |                           |
| data_type_id | integer    | null: false               |
| must_exist   | boolean    | null: false               |
| unique       | boolean    | null: false               |
| model        | references | foreign_key: true         |
| application  | references | foreign_key: true         |

### Association

- belongs_to :model
- belongs_to :application
- has_many :options

## optionsテーブル

| column         | Type       | Options                   |
| -------------- | ---------- | ------------------------- |
| option_type_id | integer    | null: false               |
| input1         | string     |                           |
| input2         | string     |                           |
| column         | references | foreign_key: true         |

### Association

- belongs_to :column

## app_controllersテーブル

| column         | Type       | Options                   |
| -------------- | ---------- | ------------------------- |
| name           | string     | null: false               |
| parent         | string     | null: false               |
| application    | references | foreign_key: true         |
| index_select   | integer    | null: false               |
| new_select     | integer    | null: false               |
| create_select  | integer    | null: false               |
| edit_select    | integer    | null: false               |
| update_select  | integer    | null: false               |
| destroy_select | integer    | null: false               |
| show_          | integer    | null: false               |

### Association

- belongs_to :application
- has_many :app_actions

## app_actionsテーブル

| column         | Type       | Options                   |
| -------------- | ---------- | ------------------------- |
| action_select  | string     | null: false               |
| target         | string     | null: false               |
| action_code_id | integer    | null: false               |
| app_controller | references | foreign_key: true         |
| application    | references | foreign_key: true         |

### Association

- belongs_to :app_controller
- belongs_to :application
