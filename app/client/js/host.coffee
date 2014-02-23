class NT.Host
	constructor: ->
		@init_socket()

		$('.btn').click =>
			@socket.emit 'reveal', 'next'

	init_socket: ->
		@socket = io.connect(location.origin)

		@socket.on 'test', (data) ->
			console.log data
