{ div, p, a, table, thead, tbody, tr, th, td } = React.DOM

table_headers = [
  "Player"
  "Matchup Winning %"
  "Matchup Count"
  "Titles Won"
]

@League = React.createClass
  getInitialState: ->
    activePlayers: _.sortBy(@filteredMetrics(), 'lifetime_win_percentage').reverse()


  filteredMetrics: ->
    _.filter @props.player_metrics, (player) ->
      player.matchup_count >= 30

  render: ->
    div
      className: "league"

      a
        href: "/leagues"
        "Back to all Leagues"

      p
        className: "league--name"
        @props.league.name

      p
        className: "league--remote-id"
        "ESPN Id: #{@props.league.remote_id}"

      a
        href: "http://games.espn.go.com/flb/leagueoffice?leagueId=#{@props.league.remote_id}"
        target: "_blank"
        "Go to League on ESPN"

      p
        className: "league--table-description"
        "Lifetime Player Win %"

      table
        className: "league--player-table"

        thead
          tr
            className: "league--player-table-headers"

            for header in table_headers
              th
                key: header
                scope: "column"
                className: "league--player-table-header"
                header

        tbody
          for player in @state.activePlayers
            tr
              key: player.name
              className: "league--player-table-player-row"

              td
                scope: "row"
                className: "league--player-table-player-row-cell"
                player.name

              td
                scope: "row"
                className: "league--player-table-player-row-cell"
                player.lifetime_win_percentage

              td
                scope: "row"
                className: "league--player-table-player-row-cell"
                player.matchup_count
      div className: "row league--buttons-container",
        div className: "small-4 columns league--buttons-gutter"
        div className: "small-4 columns league--buttons",

              td
                scope: "row"
                className: "league--player-table-player-row-cell"
                # player.titles
          LeagueButton
            onChange: @handleViewChange
            text: "Player Stats"

          LeagueButton
            onChange: @handleViewChange
            text: "Team Stats"

        div className: "small-4 columns league--buttons-gutter"



