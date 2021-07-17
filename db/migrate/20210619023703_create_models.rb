class CreateModels < ActiveRecord::Migration[6.0]
  def change
    create_table :models do |t|
      t.string :name, null: false
      t.integer :model_type_id, null: false
      t.boolean :not_only, null: false, default: true
      t.boolean :attached_image, default: false
      t.references :application, foreign_key: true
      t.timestamps
    end
  end
end
