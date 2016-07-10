class LeaguesController < ApplicationController

	helper_method :lifetime_matchup_metrics, :lifetime_team_metrics

	def index
		@leagues = League.all
	end

	def show
		@league = league
	end

	private

	def league
		@league ||= League.find params[:id]
	end

	def lifetime_matchup_metrics
		@lifetime_player_metrics = league.lifetime_player_matchup_metrics
	end

	def lifetime_team_metrics
		@lifetime_team_metrics = league.lifetime_team_metrics
	end
end
