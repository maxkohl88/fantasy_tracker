require 'rails_helper'

describe "League" do
	describe '#bootstrap_new_season' do
		before :each do
			@league = League.create name: "The People's League", remote_id: "123abc"
			@year = 2015
		end

		it 'creates a season for the league in question' do
			allow(@league).to receive(:import_weekly_results)
				.with(@year)
				.and_return true

			expect(Season).to receive(:create)
				.with(year: @year, league: @league)

			@league.bootstrap_new_season @year
		end

		it 'creates teams for a single season' do
			standings_source = Nokogiri::HTML open("spec/fixtures/2015_standings.html")

			season = Season.create league: @league, year: @year

			allow(@league).to receive(:source_doc)
				.with("http://games.espn.go.com/flb/standings?leagueId=#{@league.remote_id}&seasonId=#{@year}")
				.and_return(standings_source)

			allow(@league).to receive(:import_weekly_results)
				.with(@year)
				.and_return(true)

			allow(Season).to receive(:create)
				.with(year: @year, league: @league)
				.and_return(season)

			@league.bootstrap_new_season @year

			expect(season.teams.count).to eq 12
		end
	end
end
