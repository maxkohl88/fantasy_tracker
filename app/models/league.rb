require 'open-uri'

class League < ActiveRecord::Base
  has_many :seasons

  def index_lifetime_player_matchup_metrics
  	search = Search.new

  	unique_players.each do |player|
  		lifetime_results = player.lifetime_matchup_results
  		percentage = ((lifetime_results[:wins].to_f / lifetime_results[:total_matchups].to_f) * 100.0).round(2)

  		search.client.index index: :players, type: :rollup, body: {
  																													name: player.name,
  																													player_id: player.id,
  																													league_id: self.id,
  																													lifetime_win_percentage: percentage,
  																													matchup_count: lifetime_results[:total_matchups]
  																												}
  	end
  end

  def lifetime_player_matchup_metrics
  	search = Search.new

  	body = {
  		query: {
  			filtered: {
  				query: { match_all: {} },
  				filter: {
  					bool: {
  						must: [
  							term: {
  								league_id: self.id
  							}
  						]
  					}
  				}
  			}
  		},
  		size: 1000
  	}

  	response = search.client.search index: :players, body: body

  	docs = response['hits']['hits'].map do |doc|
  		doc['_source']
  	end

  	docs.reject! { |doc| (doc['lifetime_win_percentage'].nil? || doc['lifetime_win_percentage'].nan?) }
  	docs
  end

  def unique_players
  	teams.map { |team| team.players }.flatten.uniq { |player| player.remote_id }
  end

  def create_season(year)
  	Season.create year: year, league: self
  end

  def teams(year = nil)
  	seasons.map { |season| season.teams }.flatten.uniq
  end

  def bootstrap_new_season(year)
  	create_season year
  	import_teams year
  	import_weekly_results year
  end

  def import_teams(year)
  	season = Season.find_by league: self, year: year

  	standings = Nokogiri::HTML open("http://games.espn.go.com/flb/standings?leagueId=#{remote_id}&seasonId=#{year}")

  	table = standings.css('table.tableBody')
  	team_rows = table.css('tr.tableBody')

  	team_rows.each do |team_row|
  		attributes = team_row.css('a').first.attributes

  		unparsed_name = attributes['title'].value
  		unparsed_team_link = attributes['href'].value

  		parsed_name = unparsed_name.split(' (').first
  		parsed_remote_id = unparsed_team_link.match(/teamId=(\d*)/)[1].to_i

  		team = Team.find_or_initialize_by season: season, remote_id: parsed_remote_id

  		next if team.persisted?

  		team.name = parsed_name
  		team.save!
  	end
  end

  def import_weekly_results(year)
  	season = Season.find_by league: self, year: year

  	schedule = Nokogiri::HTML open("http://games.espn.go.com/flb/schedule?leagueId=#{remote_id}&seasonId=#{season.year}")

  	schedule_table = schedule.css('.tableBody')
  	schedule_rows = schedule_table.css('tr')

  	matchup_paths = []

  	schedule_rows.each do |row|
			matchup_path = row.css('a').last.attributes['href'].value rescue nil

			if matchup_path && matchup_path.match(/boxscorequick/)
				matchup_paths << matchup_path
			end
  	end

  	create_scoring_period_schema matchup_paths, season

  	matchup_paths.each do |matchup_path|
  		matchup = Matchup.create source_path: matchup_path,
  														 season: season,
  														 week: find_week_by_matchup_path(matchup_path, season)

  		matchup.extract_results
  	end
  end

	def find_week_by_matchup_path(path, season)
		path.match /scoringPeriodId=(\d*)/
		scoring_period = $1.to_i

		schedule = Schedule.find_by season: season

		schedule.mapping.find { |week, scoring_periods| scoring_periods.include? scoring_period }.first
	end

  def create_scoring_period_schema(matchup_paths, season)
  	schedule = Schedule.find_or_initialize_by season: season
  	return if schedule.persisted?

  	final_scoring_periods = matchup_paths.map do |path|
  		path.match /scoringPeriodId=(\d*)/
  		$1.to_i
  	end

  	final_scoring_periods.uniq.each_with_index do |final_scoring_period, index|
			first_scoring_period = index == 0 ? 0 : schedule.mapping[index].last + 1

  		schedule.mapping[index + 1] = (first_scoring_period..final_scoring_period).to_a
  	end

		schedule.save!
  end
end
