class MOE.App extends NB.Module
	constructor: ->
		super

		@expr.get '/', (req, res) ->
			res.send 'Hello World'
