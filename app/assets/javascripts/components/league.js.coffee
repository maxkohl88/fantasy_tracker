{div, button} = React.DOM
LeagueButton = React.createFactory @LeagueButton
PlayerTable = React.createFactory @PlayerTable
TeamTable = React.createFactory @TeamTable

@League = React.createClass
  getInitialState: ->
    activeView: "Player Stats"

  handleViewChange: (view) ->
    @setState activeView: view

  render: ->
    div className: "league row",
      div className: "row league--name",
        @props.league.name

      div className: "row league--buttons-container",
        div className: "small-4 columns league--buttons-gutter"
        div className: "small-4 columns league--buttons",

          LeagueButton
            onChange: @handleViewChange
            text: "Player Stats"

          LeagueButton
            onChange: @handleViewChange
            text: "Team Stats"

        div className: "small-4 columns league--buttons-gutter"

      div className: "league--content",
        if @state.activeView == "Player Stats"
          PlayerTable
            players: @props.player_metrics
        else
          TeamTable
            teams: _.sortBy(@props.team_metrics, (team) -> team["wins"]["value"]).reverse()


