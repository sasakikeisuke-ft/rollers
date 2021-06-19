class CreateAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :associations do |t|
      t.references :model, foreign_key: true
      t.integer :pair_id, null: false
      t.integer :relation_id, null: false
      t.timestamps
    end
  end
end
