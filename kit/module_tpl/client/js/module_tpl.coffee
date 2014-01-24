
# h1 animation
$('h1').transit {
	marginTop: 40
	opacity: 1
}

# socket io test
socket = io.connect('/')
socket.on('server', (data) ->
	console.log data

	socket.emit('client', 'socket client ok')
)