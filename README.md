# README



# テーブル設計

## users テーブル

| Column             | Type       | Options                   |
| ------------------ | ---------- | ------------------------- |
| nickname           | string     | null: false               |
| email              | string     | null: false, unique: true |
| encrypted_password | string     | null: false               |

### Association

- has_one : status
- has_many :links
- has_many :apps


## applications テーブル

| Column                  | Type       | Options           |
| ----------------------- | ---------- | ----------------- |
| application_name        | string     | null: false       |
| application_description | text       | null: false       |
| user                    | references | foreign_key: true |

### Association

- has_one :gemfile
- has_many :models
- has_many :controllers
- has_many :views


## gemfiles テーブル

| Column       | Type       | Options           |
| ------------ | ---------- | ----------------- |
| devise       | boolean    | null: false       |
| pry-rails    | boolean    | null: false       |
| image_magick | boolean    | null: false       |
| active_hash  | boolean    | null: false       |
| rails-i18n   | boolean    | null: false       |
| ransack      | boolean    | null: false       |
| rubocop      | boolean    | null: false       |
| rspec        | boolean    | null: false       |
| payjp        | boolean    | null: false       |
| s3           | boolean    | null: false       |
| application  | references | foreign_key: true |

### Association

- belongs_to :application
