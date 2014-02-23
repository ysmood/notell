
Nedb = require 'nedb'

class NB.Database extends NB.Module
	constructor: ->
		super

		@nedb = new Nedb(
			filename: NB.conf.db_filename
			autoload: true
		)

		# Auto compact every week.
		@nedb.persistence.setAutocompactionInterval(1000 * 60 * 60 * 24 * 7)
