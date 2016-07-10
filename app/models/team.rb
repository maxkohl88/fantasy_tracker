class Team < ActiveRecord::Base
	belongs_to :season
	has_many :team_results
	has_many :matchups, through: :team_results
	has_many :contracts
	has_many :players, through: :contracts

	def index_standings(standings)

		search.client.index index: :teams, type: :rollup, body: {
			name: name,
			team_id: id,
			remote_id: remote_id,
			season_id: season.id,
			league_id: season.league.id,
			wins: standings[:wins],
			losses: standings[:losses],
			ties: standings[:ties]
		}
	end

	private

	def search
		@search ||= Search.new
	end
end
