
Nedb = require 'nedb'

class NB.Database
	constructor: ->
		@nedb = new Nedb(
			filename: NB.conf.db_filename
			autoload: true
		)

		# Auto compact every week.
		@nedb.persistence.setAutocompactionInterval(1000 * 60 * 60 * 24 * 7)

		NB.app.get '/database', @test

	test: (req, res) =>
		@nedb.insert { test: 200 }, (err, doc) =>
			@nedb.findOne { test: 200 }, (err, doc) =>
				res.send doc.test
