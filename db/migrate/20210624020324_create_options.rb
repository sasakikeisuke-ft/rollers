class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.integer :option_type_id, null: false
      t.string :input1
      t.string :input2
      t.references :column, foreign_key: true
      t.timestamps
    end
  end
end
