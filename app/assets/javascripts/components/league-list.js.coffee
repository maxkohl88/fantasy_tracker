{div, ul, li, a, p} = React.DOM

@LeagueList = React.createClass
  render: ->
    div null,
      a 
        href: "/leagues"
        "All Leagues"
        
        
      ul 
        className: "league-list"      
        for league in @props.leagues
          li 
            className: "league-list--league"
            key: league.name          
            a
              href: "/leagues/#{league.id}"
              className: "league-list--league-name"
              league.name




