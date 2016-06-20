class LeaguesController < ApplicationController

  helper_method :lifetime_matchup_metrics

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
end
