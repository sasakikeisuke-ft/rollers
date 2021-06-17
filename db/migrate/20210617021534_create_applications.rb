class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
