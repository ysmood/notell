class NT.App extends NB.Module
	constructor: ->
		super

		@set_static_dir('app/client', '/app')

		NB.app.get '/', @home
		NB.app.get '/host', @host

		@init_socket()

	home: (req, res) =>
		data = {
			head: @r.render('assets/ejs/head.ejs')
			foot: @r.render('assets/ejs/foot.ejs')
		}

		res.send @r.render("app/client/ejs/home.ejs", data)

	host: (req, res) =>
		data = {
			head: @r.render('assets/ejs/head.ejs')
			foot: @r.render('assets/ejs/foot.ejs')
		}

		res.send @r.render("app/client/ejs/host.ejs", data)


	init_socket: ->
		NB.io.sockets.on 'connection', (socket) =>
			socket.emit 'test', 'ok'

			socket.on 'reveal', (data) ->
				console.log data
				NB.io.sockets.emit 'reveal', data
