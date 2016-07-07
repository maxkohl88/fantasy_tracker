{span} = React.DOM

@TablePageTab = React.createClass
	propTypes:
		onChange: React.PropTypes.func

	handleChange: (evnt) ->
		@props.onChange?(evnt.target.value)

	render: ->
		span
			className: "#{@props.className}"
			value: @props.value
			onClick: @handleChange
			"#{@props.value}"
