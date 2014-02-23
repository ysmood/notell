
Nedb = require 'nedb'

class NB.Database extends NB.Module
	constructor: ->
		super

		@prefix = '/' + @constructor.name.toLowerCase()

		@nedb = new Nedb(
			filename: NB.conf.db_filename
			autoload: true
		)
		# Auto compact every week.
		@nedb.persistence.setAutocompactionInterval(1000 * 60 * 60 * 24 * 7)

		# DB API
		NB.app.post(@prefix + '/insert', @insert)
		NB.app.post(@prefix + '/find', @find)
		NB.app.post(@prefix + '/find_one', @find_one)
		NB.app.post(@prefix + '/update', @update)
		NB.app.post(@prefix + '/remove', @remove)

		NB.app.get(@prefix + '/reload', @reload)

	insert: (req, res) =>
		_.sandbox(=>
			@nedb.insert(req.body, (err, doc) ->
				res.send {
					_id: doc._id
				}
			)
		, 'Database error.')

	find: (req, res) =>
		_.sandbox(=>
			@nedb.find(req.body, (err, docs) ->
				res.send docs
			)
		, 'Database error.')

	find_one: (req, res) =>
		_.sandbox(=>
			@nedb.findOne(req.body, (err, doc) ->
				res.send doc
			)
		, 'Database error.')

	update: (req, res) =>
		data = req.body
		_.sandbox(=>
			@nedb.update(data.query, data.update, data.options or {},
				(err, num_replaced, upsert) ->
					res.send {
						num_replaced: num_replaced
						upsert: upsert
					}
			)
		, 'Database error.')

	remove: (req, res) =>
		data = req.body
		_.sandbox(=>
			@nedb.remove(data.query, data.options or {}, (err, num_removed) ->
				res.send {
					num_removed: num_removed
				}
			)
		, 'Database error.')

	reload: (req, res) =>
		@nedb.loadDatabase()
		res.send 200