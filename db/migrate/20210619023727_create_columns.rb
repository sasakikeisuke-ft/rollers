class CreateColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :columns do |t|
      t.string :name, null: false
      t.string :name_ja
      t.integer :data_type_id, null: false
      t.boolean :must_exist, null: false, default: true
      t.boolean :unique, null: false, default: false
      t.references :application, foreign_key: true
      t.references :model, foreign_key: true
      t.timestamps
    end
  end
end
