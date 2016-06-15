class TeamMatchup < ActiveRecord::Base
	belongs_to :team
	belongs_to :matchup
end
