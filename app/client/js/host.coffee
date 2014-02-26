class NT.Host
	constructor: (@socket) ->
		@is_locked = false
		@zoom = null

		@init_auth()
		@init_events()
		@init_zoom()

		@socket.on 'reconnect', @init_auth

	init_events: ->
		self = @

		Reveal.addEventListener 'slidechanged', (e) =>
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'fragmentshown', (e) =>
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'fragmenthidden', (e) =>
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'paused', =>
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'resumed', =>
			@socket.emit 'state_changed', @get_state()

		@$host_panel = $('#host-panel')
		@$host_panel.find('.btn').click ->
			$this = $(this)
			switch $this.attr('action')
				when 'home'
					return if self.is_locked

					Reveal.slide 0

				when 'pause'
					return if self.is_locked

					Reveal.togglePause()
					$this.find('i').toggleClass('fa-pause fa-play')

				when 'end'
					return if self.is_locked

					Reveal.slide Number.MAX_VALUE

				when 'lock'
					self.is_locked = !self.is_locked
					$('.prevent-interaction').toggle()
					$this.find('i').toggleClass('fa-lock fa-unlock')

	init_zoom: ->
		$slides = $('.slides')
		$slides.on 'click', (e) =>
			index = _.indexOf $slides[0].getElementsByTagName('*'), e.target

			if index >= 0
				@zoom = { index: index }
				@socket.emit 'state_changed', @get_state()
			else
				@zoom = null

	get_state: ->
		state = {
			indices: Reveal.getIndices()
			zoom: @zoom
			is_paused: Reveal.isPaused()
		}
		setTimeout(=>
			@zoom = null
		, 1000)

		return state

	logged_in: =>
		_.notify {
			info: _.l('Authed')
		}

		document.title += _.l(' - Host')

		Reveal.configure {
			slideNumber: true
		}

		@$host_panel.transit_fade_in()

		@socket.emit 'state_changed', @get_state()

	init_auth: =>
		@token = localStorage.getItem('token')

		if @token
			@auth()
		else
			$msgbox = _.msg_box {
				title: _.l('Login')
				body: $('#host-login-tpl').html()
				btn_list: [
					{
						name: _.l('OK')
						clicked: =>
							$msgbox.modal('hide')
							@token = $msgbox.find('input').val()
							localStorage.setItem('token', @token)

							@auth()
					}
				]
			}

	auth: =>
		@socket.emit('auth', {
			token: @token
		}, (is_succeed) =>
			if is_succeed
				@logged_in()
			else
				_.notify {
					info: _.l(data)
					class: 'red'
				}
				localStorage.removeItem 'token'
		)
