class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.integer :action_type_id, null: false
      t.string :target, null: false
      t.integer :aciton_code_id, null: false
      t.references :app_controller, foreign_key: true
      t.string :input1
      t.string :input2
      t.string :input3
      t.timestamps
    end
  end
end
