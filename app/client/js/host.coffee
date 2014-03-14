class NT.Host
	constructor: (@socket) ->
		@is_locked = false
		@is_zoom_mode = false
		@zoom = null
		@$time = $('#timer .time')

		@init_auth()
		@init_events()
		@init_timer()
		@init_zoom()

		@socket.on 'reconnect', @init_auth

	init_events: ->
		self = @

		Reveal.addEventListener 'slidechanged', =>
			@zoom = null
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'fragmentshown', =>
			@zoom = null
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'fragmenthidden', =>
			@zoom = null
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'paused', =>
			@zoom = null
			@socket.emit 'state_changed', @get_state()

		Reveal.addEventListener 'resumed', =>
			@zoom = null
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
					$this.find('i').toggleClass 'fa-pause fa-play'

				when 'end'
					return if self.is_locked

					Reveal.slide Number.MAX_VALUE

				when 'timer'
					self.begin_time = Date.now()
					localStorage.setItem('begin_time', self.begin_time)

				when 'zoom'
					self.is_zoom_mode = !self.is_zoom_mode
					if not self.is_zoom_mode
						self.zoom == null
					$this.find('i').toggleClass 'fa-search fa-search-plus'

				when 'lock'
					self.is_locked = !self.is_locked
					$('.prevent-interaction').toggle()
					$this.find('i').toggleClass 'fa-lock fa-unlock'
			$this.blur()

	init_timer: ->
		@begin_time = +localStorage.getItem('begin_time')
		$('#timer').show()

		if not @begin_time
			@begin_time = Date.now()
			localStorage.setItem('begin_time', @begin_time)

		@timer = setInterval(=>
			now = Date.now()
			time = new Date(now - @begin_time)
			min = _.pad time.getMinutes(), 2, '0'
			sec = _.pad time.getSeconds(), 2, '0'
			@$time.text "#{min} : #{sec}"
		, 500)

	init_zoom: ->
		$slides = $('.slides')
		$slides.on 'click', (e) =>
			if not @is_zoom_mode
				@zoom = null
				return

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
						is_default: true
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
					info: _.l('Wrong Password')
					class: 'red'
				}
				localStorage.removeItem 'token'
		)
