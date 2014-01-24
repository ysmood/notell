class <%= class_name %> extends NB.Module
	constructor: ->
		super

		@name = @constructor.name.toLowerCase()

		@set_static_dir(@name + '/client', '/' + @name)

		NB.app.get '/', @home

		NB.io.sockets.on 'connection', @sock

	home: (req, res) =>
		# Load sections.
		data = {
			head: @r.render('/assets/ejs/head')
			foot: @r.render('/assets/ejs/foot')
			class_name: @name
		}

		# Render page.
		res.send @r.render('client/ejs/app', data)

	sock: (s) =>
		s.emit('server', 'socket server ok')

		s.on('client', (data) ->
			console.log data
		)
