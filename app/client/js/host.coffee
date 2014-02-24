class NT.Host
	constructor: ->
		@init_socket()
		@init_events()

	init_events: ->
		Reveal.addEventListener 'slidechanged', (e) =>
			@socket.emit 'slidechanged', Reveal.getIndices()

		Reveal.addEventListener 'fragmentshown', (e) =>
			@socket.emit 'slidechanged', Reveal.getIndices()

		Reveal.addEventListener 'fragmenthidden', (e) =>
			@socket.emit 'slidechanged', Reveal.getIndices()

		Reveal.addEventListener 'paused', =>
			@socket.emit 'paused'

		Reveal.addEventListener 'resumed', =>
			@socket.emit 'resumed'

		@$host_panel = $('#host-panel')
		@$host_panel.find('.btn').click ->
			switch $(this).attr('action')
				when 'home'
					Reveal.slide 0
				when 'pause'
					Reveal.togglePause()
				when 'end'
					Reveal.slide Number.MAX_VALUE

	logged_in: =>
		_.notify {
			info: _.l('Authed')
		}

		document.title += _.l(' - Host')

		@$host_panel.transit_fade_in()

		@socket.emit 'slidechanged', Reveal.getIndices()
		@socket.emit 'resumed'

	auth: =>
		token = localStorage.getItem('token')

		if token
			@socket.emit 'auth', {
				token: token
			}
		else
			$msgbox = _.msg_box {
				title: _.l('Login')
				body: $('#host-login-tpl').html()
				btn_list: [
					{
						name: _.l('OK')
						clicked: =>
							token = $msgbox.find('input').val()
							localStorage.setItem('token', token)
							@socket.emit 'auth', {
								token: token
							}
							$msgbox.modal('hide')
					}
				]
			}

	init_socket: ->
		@socket = io.connect(location.origin)

		@socket.on 'auth_err', (data) ->
			_.notify {
				info: _.l(data)
				class: 'red'
			}
			localStorage.removeItem 'token'

		@socket.on 'authed', @logged_in

		@socket.on 'connect', @auth
