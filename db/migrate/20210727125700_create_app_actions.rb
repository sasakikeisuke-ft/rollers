class CreateAppActions < ActiveRecord::Migration[6.0]
  def change
    create_table :app_actions do |t|

      t.timestamps
    end
  end
end
