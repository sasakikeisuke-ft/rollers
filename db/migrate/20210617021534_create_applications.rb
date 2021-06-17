class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_table :applications do |t|
      t.string :application_name, null: false
      t.text :application_description
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
