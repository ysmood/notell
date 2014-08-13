class NT.Guest
	constructor: (@socket) ->
		@init_socket()

		# $('.prevent-interaction').show()

		document.title += _.l(' - Guest')

		Reveal.configure {
			controls: false
			center: true
			keyboard: false
			touch: false
			slideNumber: false
		}

		$(document).keyup (e) =>
			switch e.keyCode
				when 70, 32, 13
					@full_screen()

	init_socket: ->
		@socket.on 'reconnect', @set_state

		@socket.emit 'get_state', {}, @set_state

		@socket.on 'state_changed', (state) =>
			@set_state state

	set_state: (state) =>
		if not state.indices
			return

		indices = state.indices
		Reveal.slide indices.h, indices.v, indices.f

		if state.zoom
			el = $('.slides')[0].getElementsByTagName('*')[state.zoom.index]
			zoom.to({ element: el })
		else
			zoom.out()

		if state.is_paused
			if not Reveal.isPaused()
				Reveal.togglePause()
		else
			if Reveal.isPaused()
				Reveal.togglePause()

	full_screen: ->

		element = document.body

		requestMethod = element.requestFullScreen or
							element.webkitRequestFullscreen or
							element.webkitRequestFullScreen or
							element.mozRequestFullScreen or
							element.msRequestFullScreen

		if requestMethod
			requestMethod.apply element
