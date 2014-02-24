
class NT.Notell
	constructor: ->
		@init_revealjs()

		if _.startsWith(location.pathname, '/host')
			@init_host()
		else
			@init_guest()

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

	init_host: ->
		@host = new NT.Host

	init_guest: ->
		@guest = new NT.Guest