{div, span, table, thead, tbody, tr, th, td} = React.DOM

TablePageTab = React.createFactory @TablePageTab

table_headers = [
  "Player"
  "Matchup Winning %"
  "Matchup Count"
  "Titles Won"
]

@PlayerTable = React.createClass
	getInitialState: ->
	  activePlayers: @chunkedPlayers()[0]

	filteredPlayers: ->
		_.filter @props.players, (player) ->
			player.matchup_count >= 30

	playerBucketCount: ->
		parseInt(_.size(@filteredPlayers()) / 50) + 1

	sortedPlayers: ->
		_.sortBy(@filteredPlayers(), 'lifetime_win_percentage').reverse()

	chunkedPlayers: ->
		_.groupBy @sortedPlayers(), (elem, index) ->
			Math.floor index/50

	handleTabChange: (tab) ->
		@setState activePlayers: @chunkedPlayers()[tab - 1]

	render: ->
		div className: "league--player-table-container",
			div className: "league--player-table-tabs",
				_.times @playerBucketCount(), (index) =>
					TablePageTab
						className: "league--player-table-tab"
						value: index + 1
						onChange: @handleTabChange

	  table className: "league--player-table",
	    thead className: "league--player-table-head",
	      tr className: "league--player-table-headers",
	        for header in table_headers
	        	th
	        		key: header
	        		className: "league--player-table-header"
	        		header

	    tbody className: "league--player-table-body",
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

	          td
	            scope: "row"
	            className: "league--player-table-player-row-cell"
	            # player.titles
