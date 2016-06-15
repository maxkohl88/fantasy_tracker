class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :remote_id
      t.string :team_abbreviation
      t.string :position

      t.timestamps
    end
  end
end
