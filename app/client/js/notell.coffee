
class NT.Notell
	constructor: ->
		console.log 'notell'

	init_sockets: ->
		socket = io.connect(location.origin)