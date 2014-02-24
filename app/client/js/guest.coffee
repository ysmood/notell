class NT.Guest
	constructor: ->
		@init_socket()

	init_socket: ->
		@socket = io.connect location.origin

		@socket.on 'slidechanged', (indices) =>
			Reveal.slide indices.h, indices.v, indices.f
