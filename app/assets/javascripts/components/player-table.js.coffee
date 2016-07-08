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
		div className: "league--table-container",
			div className: "league--player-table-tabs",
				_.times @playerBucketCount(), (index) =>
					TablePageTab
						className: "league--player-table-tab"
						value: index + 1
						onChange: @handleTabChange

	  table className: "league--table",
	    thead className: "league--table-head",
	      tr className: "league--table-headers",
	        for header in table_headers
	        	th
	        		key: header
	        		className: "league--table-header"
	        		header

	    tbody className: "league--table-body",
	      for player in @state.activePlayers
	        tr
	          key: player.name
	          className: "league--table-row"

	          td
	            scope: "row"
	            className: "league--table-cell"
	            player.name

	          td
	            scope: "row"
	            className: "league--table-cell"
	            player.lifetime_win_percentage

	          td
	            scope: "row"
	            className: "league--table-cell"
	            player.matchup_count

	          td
	            scope: "row"
	            className: "league--table-cell"
	            # player.titles
