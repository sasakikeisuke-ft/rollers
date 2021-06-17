class CreateGemfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :gemfiles do |t|
      t.boolean :devise,       null: false, default: true
      t.boolean :pry_rails,    null: false, default: true
      t.boolean :image_magick, null: false, default: false
      t.boolean :active_hash,  null: false, default: false
      t.boolean :rails_i18n,   null: false, default: false
      t.boolean :ransack,      null: false, default: false
      t.boolean :rubocop,      null: false, default: false
      t.boolean :rspec,        null: false, default: false
      t.boolean :payjp,        null: false, default: false
      t.boolean :s3,           null: false, default: false
      t.references :application, foreign_key: true
      t.timestamps
    end
  end
end
