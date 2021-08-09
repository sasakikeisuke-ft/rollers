class CreateAppActions < ActiveRecord::Migration[6.0]
  def change
    create_table :app_actions do |t|
      t.string :action_select, null: false
      t.string :target, null: false
      t.integer :action_code_id, null: false
      t.references :app_controller, foreign_key: true
      t.references :application, foreign_key: true
      t.string :input1
      t.string :input2
      t.string :input3
      t.timestamps
    end
  end
end
