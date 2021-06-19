class CreateAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :associations do |t|
      t.integer :left, null: false
      t.integer :right, null: false
      t.integer :relation_id, null: false
      t.references :application, foreign_key: true
      t.timestamps
    end
  end
end
