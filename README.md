# README

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
