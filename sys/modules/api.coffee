class NB.Api
	constructor: ->
		NB.app.get '/api', @test

	test: (req, res) =>
		res.send 200
