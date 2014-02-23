
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
		data = { test: 200 }
		@nedb.insert data, (err, doc) =>
			@nedb.findOne data, (err, doc) =>
				@nedb.remove data, (err, num) =>
					res.send doc.test
