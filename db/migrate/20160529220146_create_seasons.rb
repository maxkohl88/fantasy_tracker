class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
    	t.integer :year
    	t.references :league, index: true

    	t.timestamps
    end
  end
end
