class NT.App extends NB.Module
	constructor: ->
		super

		@state = {
			indices: { h: 0, v: 0, f: 0 }
			is_paused: false
		}

		@set_static_dir('app/client', '/app')

		NB.app.get '/', @home
		NB.app.get '/:doc_path', @home

		@init_sockets()

	home: (req, res, next) =>
		fs = require 'fs-extra'
		if req.params.doc_path
			path = 'usr/' + req.params.doc_path
			if not _.endsWith(path, '.ejs')
				path += '.ejs'
			if not fs.existsSync(path)
				next()
				return
		else
			path = NB.conf.default
			if not _.endsWith(path, '.ejs')
				path += '.ejs'

		data = {
			head: @r.render 'assets/ejs/head.ejs'
			foot: @r.render 'assets/ejs/foot.ejs'
			host_assets: @r.render 'app/client/ejs/assets.ejs'
			reveal: @r.render path
		}

		res.send @r.render("app/client/ejs/home.ejs", data)

	auth_host: (socket) ->
		socket.on 'auth', (data, resp_fn) =>
			is_host = data.token == NB.conf.token
			if is_host
				@init_host_socket socket

				socket.set('role', 'host')

				console.log '>> Host authed.'.c('yellow')
			else
				console.log '>> Host auth failed.'.c('red')

			resp_fn is_host

	init_sockets: ->
		NB.io.sockets.on 'connection', (socket) =>
			socket.set('role', 'guest')

			@client_connected socket

			@auth_host socket

		# Auto reload page when file changed.
		NB.nobone.emitter.on 'code_reload', (path) ->
			NB.io.sockets.emit 'code_reload', path

	client_connected: (socket) ->
		console.log '>> A connected.'.c('green')
		client_num = NB.io.sockets.clients().length
		console.log ">> Client count: #{client_num}".c('green')

		socket.on 'get_state', (data, resp_fn) =>
			resp_fn @state

		socket.on 'disconnect', ->
			role = socket.store.data.role.toUpperCase()
			console.log ">> A #{role} disconnected.".c('red')

	init_host_socket: (socket) ->
		# Boardcast the host state to all clients.
		socket.on 'state_changed', (state) =>
			@state = state
			info = JSON.stringify state
			console.log ">> State changed: #{info}".blue
			socket.broadcast.emit 'state_changed', state
