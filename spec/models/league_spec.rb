require 'rails_helper'

describe "League" do
	describe '#bootstrap_new_season' do
		before :each do
			@league = League.create name: "The People's League", remote_id: "123abc"
			@year = 2015

			@standings_source = Nokogiri::HTML open("spec/fixtures/2015_standings.html")
			@schedule_source = Nokogiri::HTML open("spec/fixtures/2015_schedule.html")

			allow(@league).to receive(:source_doc)
				.with("http://games.espn.go.com/flb/standings?leagueId=#{@league.remote_id}&seasonId=#{@year}")
				.and_return(@standings_source)

			allow(@league).to receive(:source_doc)
				.with("http://games.espn.go.com/flb/schedule?leagueId=#{@league.remote_id}&seasonId=#{@year}")
				.and_return(@schedule_source)

			@season = Season.create league: @league, year: @year
		end

		it 'creates a season for the league in question' do
			allow(@league).to receive(:import_teams)
				.with(@year, @standings_source)
				.and_return true

			allow(@league).to receive(:import_weekly_results)
				.with(@year, @schedule_source)
				.and_return true

			expect(Season).to receive(:create)
				.with(year: @year, league: @league)

			@league.bootstrap_new_season @year
		end

		it 'creates teams for a single season' do
			allow(@league).to receive(:import_weekly_results)
				.with(@year, @schedule_source)
				.and_return(true)

			allow(Season).to receive(:create)
				.with(year: @year, league: @league)
				.and_return(@season)

			@league.bootstrap_new_season @year

			expect(@season.teams.count).to eq 12
		end

		it 'creates a schedule for a single season' do
			expected_schedule_schema = JSON.parse File.read("spec/fixtures/2015_schedule_mapping.txt")

			allow(Season).to receive(:create)
				.with(year: @year, league: @league)
				.and_return @season

			allow(@league).to receive(:import_teams)
				.with(@year, @standings_source)
				.and_return true

			allow(Matchup).to receive(:create)
				.and_return(Matchup.new)

			allow_any_instance_of(Matchup).to receive(:extract_results)
				.and_return true

			@league.bootstrap_new_season @year

			schedule = Schedule.find_by season: @season

			expect(schedule.mapping).to eq(expected_schedule_schema)
		end
	end
end
