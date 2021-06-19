class CreateModels < ActiveRecord::Migration[6.0]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.integer :type, null: false
      t.references :application, foreign_key: true
      t.timestamps
    end
  end
end
