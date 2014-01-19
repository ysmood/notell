class NB.Api extends NB.Module
	constructor: ->
		super

		@app.get '/api/test', @test

	test: (req, res) =>
		res.send 200
