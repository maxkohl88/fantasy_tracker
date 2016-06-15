class CreateMatchups < ActiveRecord::Migration[5.0]
  def change
    create_table :matchups do |t|
    	t.integer :week
    	t.string :source_path
    	t.references :season, index: true

    	t.timestamps
    end
  end
end
