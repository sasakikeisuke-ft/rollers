class CreateAppControllers < ActiveRecord::Migration[6.0]
  def change
    create_table :app_controllers do |t|
      t.string :name, null: false
      t.string :parent
      t.references :application, foreign_key: true
      t.string :target
      t.integer :index_select, null: false
      t.integer :new_select, null: false
      t.integer :create_select, null: false
      t.integer :edit_select, null: false
      t.integer :update_select, null: false
      t.integer :destroy_select, null: false
      t.integer :show_select, null: false
      t.timestamps
    end
  end
end
