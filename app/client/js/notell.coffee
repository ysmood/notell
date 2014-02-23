
class NT.Notell
	constructor: ->
		@init_revealjs()

		@init_socket()

		_.msg_box {
			title: 'test'
			body: 'test'
		}

	init_revealjs: ->
		Reveal.initialize {
			controls: true
			progress: true
			history: true
			center: true

			theme: Reveal.getQueryHash().theme
			transition: Reveal.getQueryHash().transition or 'default'

			dependencies: [
				{ src: '/reveal.js/plugin/highlight/highlight.js', async: true, callback: -> hljs.initHighlightingOnLoad() }
				{ src: '/reveal.js/plugin/zoom-js/zoom.js', async: true, condition: -> !!document.body.classList }
				{ src: '/reveal.js/plugin/notes/notes.js', async: true, condition: -> !!document.body.classList }
			]
		}

	init_socket: ->
		@socket = io.connect location.origin

		@socket.on 'test', (data) ->
			console.log data

		@socket.on 'reveal', (cmd) ->
			console.log cmd
			switch cmd
				when 'next'
					Reveal.next()
