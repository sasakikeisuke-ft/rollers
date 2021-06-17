class CreateGemfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :gemfiles do |t|

      t.timestamps
    end
  end
end
