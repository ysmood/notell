class NT.App extends NB.Module
	constructor: ->
		super

		@set_static_dir('app/client', '/app')

		NB.app.get '/', @home
		NB.app.get '/host', @home

		@init_socket()

	home: (req, res) =>
		data = {
			head: @r.render('assets/ejs/head.ejs')
			foot: @r.render('assets/ejs/foot.ejs')
			host_assets: @r.render('app/client/ejs/host_assets.ejs')
		}

		res.send @r.render("app/client/ejs/home.ejs", data)

	auth_host: (socket, done) ->
		socket.on 'auth', (data) ->
			done data.token == NB.conf.token

	init_socket: ->
		NB.io.sockets.on 'connection', (socket) =>
			@auth_host socket, (is_host) ->
				if is_host
					socket.emit 'authed', 'ok'
					console.log '>> Host authed.'.c('yellow')
				else
					socket.emit 'auth_err', 'wrong token'
					console.log '>> Host auth failed.'.c('red')
					return

				# Boardcast the host state to all clients.
				socket.on 'slidechanged', (data) ->
					console.log ">> slidechanged".blue
					NB.io.sockets.emit 'slidechanged', data
