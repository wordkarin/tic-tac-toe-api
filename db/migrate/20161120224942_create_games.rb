class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.text :json_data

      t.timestamps
    end
  end
end
