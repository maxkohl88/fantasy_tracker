class Team < ActiveRecord::Base
	belongs_to :season
	has_many :team_results
	has_many :matchups, through: :team_results
	has_many :contracts
	has_many :players, through: :contracts
end
