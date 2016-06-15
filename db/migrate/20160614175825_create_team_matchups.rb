class CreateTeamMatchups < ActiveRecord::Migration[5.0]
  def change
    create_table :team_matchups do |t|
    	t.references :team, index: true
    	t.references :matchup, index: true
    end
  end
end
