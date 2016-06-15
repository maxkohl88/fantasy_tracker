class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
        t.string :type
    	t.string :interval
    	t.integer :year
    	t.integer :week
    	t.integer :scoring_period
    	t.integer :points

    	t.references :team, index: true
    	t.references :player, index: true
    	t.references :matchup, index: true

    	t.timestamps
    end
  end
end
