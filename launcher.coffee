###
	This is the main entrance of the project.
###

_init_timestamp = Date.now()

global.NB = {}

require './sys/module'

class NB.App extends NB.Module
	constructor: ->
		super

		NB.app = @

		# Must be init first.
		@init_config()

		@init_database()
		@init_storage()
		@init_api()
		@init_plugins()

		@init_global_router()

	init_config: ->
		# Set the body parser.
		@app.use(@express.json())
		@app.use(@express.urlencoded())

	init_global_router: ->
		@app.use(@express.static('bower_components'))
		@set_static_dir('assets')
		@app.use('/usr', @express.static('usr'))

		@app.use(@express.favicon('assets/img/NB.png'))

		@app.get('/', @home)

		@app.use(@show_404)

	init_module: (name) ->
		require "../#{name}/#{name}"

		NB[name] = new NB[_.class_name(name)]
		NB[name].set_static_dir("#{name}/client", "/#{name}")

	init_database: ->
		require './sys/database'
		@db = new NB.Database

	init_storage: ->
		require './sys/storage'
		NB.storage = new NB.Storage

	init_api: ->
		require './sys/api'
		NB.api = new NB.Api

	init_plugins: ->
		require './sys/plugin'

		NB.Plugins = {}
		NB.plugins = {}

		_.walk_files 'plugins', (path) ->
			require '../' + path

		for name, Plugin of NB.Plugins
			_.valid_class(Plugin)
			plugin = new Plugin
			NB.plugins[name.toLowerCase()] = plugin

	home: (req, res) =>
		res.send 200

	show_404: (req, res, next) =>
		if _.find_route(@app.routes, req.path)
			next()
			return

		data = {
			head: @r.render('/assets/sections/head')
			url: req.originalUrl
		}
		res.status(404)
		res.send @r.render('/assets/404', data)
		console.error ('>> 404: ' + req.originalUrl).c('red')

	launch: ->
		@app.listen @conf.port
		console.log ("""
			*** #{@package.name.toUpperCase()} #{@package.version} ***
			>> Node version: #{process.version}
			>> Start at port: #{@conf.port}
		""").c('cyan')


# Launch the application.
app = new NB.App
app.launch()

console.log ">> Took #{Date.now() - _init_timestamp}ms to startup.".c('cyan')