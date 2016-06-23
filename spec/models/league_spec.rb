require 'rails_helper'

describe "League" do
	describe '#bootstrap_new_season' do
		it 'creates a season for the league in question' do
			league = League.create name: "My League", remote_id: "123abc"
			year = 2016

			allow(league).to receive(:import_teams)
				.with(year)
				.and_return true

			allow(league).to receive(:import_weekly_results)
				.with(year)
				.and_return true

			expect(Season).to receive(:create)
				.with(year: year, league: league)

			league.bootstrap_new_season year
		end
	end
end
