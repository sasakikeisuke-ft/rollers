# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_27_125700) do

  create_table "app_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "action_select", null: false
    t.string "target", null: false
    t.integer "action_code_id", null: false
    t.bigint "app_controller_id"
    t.bigint "application_id"
    t.string "input1"
    t.string "input2"
    t.string "input3"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_controller_id"], name: "index_app_actions_on_app_controller_id"
    t.index ["application_id"], name: "index_app_actions_on_application_id"
  end

  create_table "app_controllers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "parent"
    t.bigint "application_id"
    t.string "target"
    t.integer "index_select", null: false
    t.integer "new_select", null: false
    t.integer "create_select", null: false
    t.integer "edit_select", null: false
    t.integer "update_select", null: false
    t.integer "destroy_select", null: false
    t.integer "show_select", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_app_controllers_on_application_id"
  end

  create_table "applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "columns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_ja"
    t.integer "data_type_id", null: false
    t.boolean "must_exist", null: false
    t.boolean "unique", null: false
    t.bigint "application_id"
    t.bigint "model_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_columns_on_application_id"
    t.index ["model_id"], name: "index_columns_on_model_id"
  end

  create_table "gemfiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "devise", default: true, null: false
    t.boolean "pry_rails", default: true, null: false
    t.boolean "image_magick", default: false, null: false
    t.boolean "active_hash", default: false, null: false
    t.boolean "rails_i18n", default: false, null: false
    t.boolean "ransack", default: false, null: false
    t.boolean "rubocop", default: false, null: false
    t.boolean "rspec", default: false, null: false
    t.boolean "payjp", default: false, null: false
    t.boolean "s3", default: false, null: false
    t.bigint "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_gemfiles_on_application_id"
  end

  create_table "models", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "model_type_id", null: false
    t.boolean "not_only", default: true, null: false
    t.boolean "attached_image", default: false
    t.bigint "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_models_on_application_id"
  end

  create_table "options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "option_type_id", null: false
    t.string "input1"
    t.string "input2"
    t.bigint "column_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["column_id"], name: "index_options_on_column_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nickname", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "app_actions", "app_controllers"
  add_foreign_key "app_actions", "applications"
  add_foreign_key "app_controllers", "applications"
  add_foreign_key "applications", "users"
  add_foreign_key "columns", "applications"
  add_foreign_key "columns", "models"
  add_foreign_key "gemfiles", "applications"
  add_foreign_key "models", "applications"
  add_foreign_key "options", "columns"
end
