class Season < ActiveRecord::Base
	belongs_to :league
	has_one :schedule
	has_many :teams
	has_many :matchups

	def standings
		standings_hash = {}

		matchups.each do |matchup|
			next if matchup.week > 21

			result_one = matchup.team_results.first
			result_two = matchup.team_results.last

			[result_one, result_two].each do |result|
				standings_hash[result.team_id] = { wins: 0, losses: 0, ties: 0} unless standings_hash.has_key?(result.team_id)
			end

			if result_one.points > result_two.points
				standings_hash[result_one.team_id][:wins] += 1
				standings_hash[result_two.team_id][:losses] += 1
			elsif result_one.points < result_two.points
				standings_hash[result_one.team_id][:losses] += 1
				standings_hash[result_two.team_id][:wins] += 1
			else
				standings_hash[result_one.team_id][:ties] += 1
				standings_hash[result_two.team_id][:ties] += 1
			end
		end

		standings_hash
	end

	def standings_paired_to_remote_ids
		paired_hash = {}

		standings.each do |team_id, standings|
			team = Team.find_by season: self, id: team_id

			paired_hash[team.remote_id] = standings
		end

		paired_hash
	end
end
