require 'open-uri'

class Matchup < ActiveRecord::Base
  belongs_to :season
  has_many :team_results
  has_many :teams, through: :team_results


  def extract_results
    teams = remote_team_ids.map { |remote_id| Team.find_by remote_id: remote_id, season: season }

    teams.each { |team| self.teams << team }

    self.save

    scoring_period = source_path.match(/scoringPeriodId=(\d*)/)[1].to_i

    weekly_team_results = teams.map do |team|
      TeamResult.create interval: "weekly",
                        year: season.year,
                        week: find_week_by_scoring_period(scoring_period),
                        scoring_period: scoring_period,
                        points: team_points(team.remote_id, scoring_period),
                        team: team,
                        matchup: self
    end

    player_result_tables = @source.css('table.tableBody')[1..2]

    teams_with_players = Hash[remote_team_ids.zip(player_result_tables)]

    teams_with_players.each do |remote_team_id, player_result_table|
      player_rows = player_result_table.css('tr.pncPlayerRow')

      player_rows.each do |player_row|
        player_info = player_row.children.first
        player_stats = player_row.children.last

        player_remote_id = player_info.attributes['id'].value.match(/playername_(\d*)/)[1].to_i

        matched_player_info = player_info.children.first.text.match /([a-zA-Z\s\-']*),\s(\w*).(\w*)/

        player_name = $1
        team_abbreviation = $2
        position = $3

        if matched_player_info.blank?
          player_name = player_info.children.first.children.first.text

          info_string = player_info.children.last.text.match /, (\w*).(\w*)/
          team_abbreviation = $1
          position = $2
        end

        team = Team.find_by season: self.season, remote_id: remote_team_id
        player = Player.find_or_initialize_by remote_id: player_remote_id

        player.name = player_name
        player.team_abbreviation = team_abbreviation
        player.position = position

        player.save!

        player_points = player_stats.children.first.text.to_i

        existing_contract = Contract.find_by team: team, player: player

        unless existing_contract
          Contract.create team: team, player: player
        end

        PlayerResult.create interval: "weekly",
                            year: season.year,
                            week: find_week_by_scoring_period(scoring_period),
                            scoring_period: scoring_period,
                            points: player_points,
                            team: team,
                            player: player,
                            matchup: self
      end
    end
  end

  def find_week_by_scoring_period(scoring_period)
    schedule = Schedule.find_by season: season

    schedule.mapping.find { |week, scoring_periods| scoring_periods.include? scoring_period }.first
  end

  def source
    @source ||= Nokogiri::HTML open("http://games.espn.go.com#{source_path}")
  end

  def team_results_table
    source.css('table.tableBody').first
  end

  def team_results_rows
    team_results_table.css('tr.tableBody')
  end

  def remote_team_ids
    raw_id_spans = team_results_rows.css('span').select { |elem| elem.attributes['id'] }
    parsed_id_spans = raw_id_spans.select { |elem| elem.attributes['id'].value.match(/tmTotalPoints/) }

    parsed_id_spans.map { |elem| elem.attributes['id'].value.split("_")[1].to_i }
  end

  def team_points(remote_team_id, scoring_period)
    team_results_rows.css("#tmTotalPoints_#{remote_team_id}_sp_#{scoring_period}").text.to_i
  end
end
