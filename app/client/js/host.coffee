class NT.Host
	constructor: ->
		@init_socket()
		@init_events()

	init_events: ->
		Reveal.addEventListener 'slidechanged', (e) =>
			@socket.emit 'slidechanged', Reveal.getIndices()

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

		@socket.on 'authed', (data) ->
			_.notify {
				info: _.l('Authed')
			}

		@socket.on 'connect', @auth
