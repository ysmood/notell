###
	This is the main entrance of the project.
###

_init_timestamp = Date.now()

global.NB = {}

require './sys/module'

class NB.Nobone extends NB.Module
	constructor: ->
		super

		NB.nobone = @

		# Must be init first.
		@init_config()

		@init_modules()

		@init_global_router()

	init_config: ->
		# Set the body parser.
		NB.app.use(NB.express.json())
		NB.app.use(NB.express.urlencoded())

	init_global_router: ->
		NB.app.use(NB.express.static('bower_components'))
		@set_static_dir('assets')
		NB.app.use('/usr', NB.express.static('usr'))

		NB.app.use(NB.express.favicon('assets/img/NB.png'))

		NB.app.use(@show_404)

	init_modules: ->
		for name, path of NB.conf.modules
			m = name.match /^(.+)\.(.+)$/
			namespace = m[1]
			class_name = m[2]

			ns = global[namespace] ?= {}
			require path

			ns[class_name.toLowerCase()] = new ns[class_name]

			console.log ">> Load module: #{name}:#{path}".c('green')

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

	show_404: (req, res, next) =>
		if _.find_route(NB.app.routes, req.path)
			next()
			return

		data = {
			head: @r.render('assets/ejs/head.ejs')
			url: req.originalUrl
		}
		res.status(404)
		res.send @r.render('assets/ejs/404.ejs', data)
		console.error ('>> 404: ' + req.originalUrl).c('red')

	launch: ->
		NB.server.listen NB.conf.port
		console.log ("""
			*** #{NB.package.name.toUpperCase()} #{NB.package.version} ***
			>> Node version: #{process.version}
			>> Start at port: #{NB.conf.port}
		""").c('cyan')


# Launch the application.
new NB.Nobone

NB.nobone.launch()

console.log ">> Took #{Date.now() - _init_timestamp}ms to startup.".c('cyan')