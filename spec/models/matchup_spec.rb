require 'rails_helper'

describe 'Matchup' do
	describe '#extract_results' do
		it 'stores the teams involved' do
			league = League.create name: "The People's League", remote_id: "123abc"
			season = Season.create league: league, year: 2015
			matchup = Matchup.create source_path: "/leagueId=sandwich", season: season, week: 1

			matchup_fixture = Nokogiri::HTML open("spec/fixtures/matchup_fixture_2015.html")

			allow(matchup).to receive(:source)
				.and_return matchup_fixture

			team_one = Team.create remote_id: 1, season: season
			team_two = Team.create remote_id: 3, season: season

			pending("this will be a mess, refactor matchup")

			matchup.extract_results

			expect(matchup.teams).to include(team_one, team_two)
		end
	end
end
