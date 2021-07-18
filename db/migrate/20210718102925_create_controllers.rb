class CreateControllers < ActiveRecord::Migration[6.0]
  def change
    create_table :controllers do |t|
      t.string :name, null: false
      t.string :parent
      t.references :application, foreign_key: true
      t.string :target
      t.integer :index, null: false
      t.integer :new, null: false
      t.integer :create, null: false
      t.integer :edit, null: false
      t.integer :update, null: false
      t.integer :destroy, null: false
      t.integer :show, null: false
      t.timestamps
    end
  end
end
