class NT.Guest
	constructor: (@socket) ->
		@init_socket()

		$('.prevent-interaction').show()

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

		@socket.on 'slidechanged', (indices) =>
			Reveal.slide indices.h, indices.v, indices.f

		@socket.on 'paused', =>
			if not Reveal.isPaused()
				Reveal.togglePause()

		@socket.on 'resumed', =>
			if Reveal.isPaused()
				Reveal.togglePause()

	set_state: (state) =>
		indices = state.indices
		Reveal.slide indices.h, indices.v, indices.f

		if state.is_paused and not Reveal.isPaused()
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
