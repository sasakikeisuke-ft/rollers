class CreateColumns < ActiveRecord::Migration[6.0]
  def change
    create_table :columns do |t|
      t.string :name, null: false
      t.integer :data_option_id, null: false
      t.references :model, foreign_key: true
      t.timestamps
    end
  end
end
