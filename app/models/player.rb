class Player < ActiveRecord::Base
	has_many :player_results
	has_many :matchups, through: :player_results
	has_many :contracts
	has_many :teams, through: :contracts

	def index_lifetime_matchup_results(league_id)
		lifetime_results = lifetime_matchup_results
		percentage = ((lifetime_results[:wins].to_f / lifetime_results[:total_matchups].to_f) * 100.0).round(2)

		search.index index: :players, type: :rollup, body: {
																													name: name,
																													player_id: id,
																													league_id: league_id,
																													lifetime_win_percentage: percentage,
																													matchup_count: lifetime_results[:total_matchups]
																												}
	end

	private

	def lifetime_matchup_results
		results_hash = { wins: 0, losses: 0, ties: 0, total_matchups: 0 }

		matchups.each do |matchup|
			next if matchup.week > 21
			results = TeamResult.where matchup: matchup

			player_team = results.each do |result|
				player_result = PlayerResult.find_by matchup: matchup, team: result.team, player: self
				break result.team if player_result
			end

			player_team_result = results.find { |result| result.team_id == player_team.id }
			other_team_result = results.find { |result| result.team_id != player_team.id }

			if player_team_result.points > other_team_result.points
				results_hash[:wins] += 1
			elsif player_team_result.points < other_team_result.points
				results_hash[:losses] += 1
			else
				results_hash[:ties] += 1
			end

			results_hash[:total_matchups] += 1
		end

		results_hash
	end

	private

	def search
		@search ||= Elasticsearch::Client.new
	end
end
