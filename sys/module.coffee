###
	Base class of the server.
	Here is a list of all properties that can be used by a child.
	Global libs:
		@underscore _
		@underscore.string _
		@underscore.helpers _ helpers.coffee

	Module: {
		@r
			Module wide renderer.
		@emitter
			Module wide event manager.
	}
###

global.NB ?= {}

class NB.Module

	set_static_dir: (root_dir, pattern = '/') ->
		NB.app.use(pattern, (req, res, next) ->
			fs_path = require 'path'

			ext = fs_path.extname(req.path)

			switch ext
				when '.js'
					ext_from = '.coffee'
					ext_to = '.js'
					content_type = 'application/javascript'
					compiler = (str) ->
						coffee = require 'coffee-script'
						return coffee.compile(str, { bare: true })

				when '.css'
					ext_from = '.styl'
					ext_to = '.css'
					content_type = 'text/css'
					compiler = (str, path) ->
						ret = ''
						stylus = require 'stylus'
						stylus.render(str, { filename: path }, (err, css) ->
							if err
								throw err
							else
								ret = css
						)
						return ret
				else
					next()
					return

			path = root_dir + req.path

			path_from =
				fs_path.dirname(path) +
				fs_path.sep +
				fs_path.basename(path, ext_to) +
				ext_from

			fs = require 'fs'
			if not fs.existsSync(path_from)
				next()
				return

			code = _.get_cached_code(path_from, compiler)

			res.set('Content-Type', content_type)
			res.send code
		)

		NB.app.use(pattern, NB.express.static(root_dir))

	constructor: ->
		@_load_confs()
		@_load_langs()
		@_load_global_libs()
		@_init_server()
		@_init_renderer()
		@_init_emitter()

	_load_confs: ->
		NB.package ?= require '../package.json'
		require '../var/config'

		NB.conf.enable_socket_io = true

		NB.conf.modules = {
			'NT.App': './app/app'
		}

	_load_langs: ->
		NB.langs ?= {}
		for lang in NB.conf.load_langs
			require '../assets/langs/' + lang

	_load_global_libs: ->
		# Load underscore.
		if not _
			_ = require 'underscore'
			global._ = _

			_.str = require 'underscore.string'
			_.mixin _.str.exports()
			_.str.include 'Underscore.string', 'string'

			require './helpers'

		if NB.conf.mode != 'product'
			require 'colors'

	_init_server: ->
		if not NB.express
			NB.express = require('express')
			NB.app = NB.express()
			NB.server = require('http').Server(NB.app)

			# Sokect.io
			if NB.conf.enable_socket_io
				NB.io = require('socket.io').listen(NB.server)
				NB.io.set('log level', 1)

	_init_renderer: ->
		if not NB.Renderer
			require './renderer'

		class_name = @constructor.name.toLowerCase()
		@r = new NB.Renderer class_name

	_init_emitter: ->
		events = require 'events'
		@emitter = new events.EventEmitter
