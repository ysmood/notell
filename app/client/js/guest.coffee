class NT.Guest
	constructor: ->
		@init_socket()

		document.title += _.l(' - Guest')

	init_socket: ->
		@socket = io.connect location.origin

		@socket.on 'state', (state) =>
			indices = state.indices
			Reveal.slide indices.h, indices.v, indices.f

			if state.is_paused and not Reveal.isPaused()
				Reveal.togglePause()

		@socket.on 'slidechanged', (indices) =>
			Reveal.slide indices.h, indices.v, indices.f

		@socket.on 'paused', =>
			if not Reveal.isPaused()
				Reveal.togglePause()

		@socket.on 'resumed', =>
			if Reveal.isPaused()
				Reveal.togglePause()