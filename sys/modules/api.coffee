class NB.Api extends NB.Module
	constructor: ->
		super

		NB.app.get '/api/test', @test

	test: (req, res) =>
		res.send 200
