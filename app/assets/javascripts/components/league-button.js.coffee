{div, button} = React.DOM

@LeagueButton = React.createClass
  propTypes:
    onChange: React.PropTypes.func

  handleChange: (evnt) ->
    @props.onChange?(evnt.target.value)

  render: ->
    button
      className: "league--button"
      onClick: @handleChange
      value: @props.text
      @props.text
