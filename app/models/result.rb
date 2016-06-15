class Result < ActiveRecord::Base
	belongs_to :team
	belongs_to :matchup
	belongs_to :player
end
