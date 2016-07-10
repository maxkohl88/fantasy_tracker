{div, table, thead, tbody, tr, th, td} = React.DOM

table_headers = [
	"Team"
	"Win %"
	"Wins"
	"Losses"
	"Ties"
]

@TeamTable = React.createClass
	propTypes:
		teams: React.PropTypes.array

	calculateWinPercentage: (team) ->
		"#{Math.round((team.wins.value / (team.wins.value + team.losses.value + team.ties.value)) * 10000) / 100} %"

	render: ->
		div className: "league--table-container",
			table className: "league--table",
				thead className: "league--table-head",
					tr className: "league--table-headers",
						for header in table_headers
							th
								key: header
								className: "league--table-header"
								header

				tbody className: "league--table-body",
					for team in @props.teams
						tr
							key: team["name"]
							className: "league--table-row"

							td className: "league--table-cell", team["name"]
							td className: "league--table-cell",
								@calculateWinPercentage(team)
							td className: "league--table-cell", team["wins"]["value"]
							td className: "league--table-cell", team["losses"]["value"]
							td className: "league--table-cell", team["ties"]["value"]




