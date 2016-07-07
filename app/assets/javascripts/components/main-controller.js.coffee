{div} = React.DOM
LeagueList = React.createFactory @LeagueList

@MainController = React.createClass
  render: ->
    div className: "main-container",
      div className: "main--league-list-container",
        LeagueList
          leagues: @props.leagues

