class NT.Notell
	constructor: ->
		@socket = io.connect(location.origin, {
			'reconnection limit': 500
			'max reconnection attempts': 100000
		})

		@init_revealjs()

		Reveal.addEventListener 'ready', @init_role

		@init_auto_refresh()

	init_role: =>
		self = @

		if localStorage.getItem('token')
			@init_host()
			return

		$msg_box = _.msg_box {
			title: _.l("Choose your role")
			body: $('#role-option-tpl').html()
		}
		$msg_box.find('.btn').click ->
			mode = $(this).attr('mode')
			switch mode
				when 'guest'
					self.init_guest()
				when 'host'
					self.init_host()
				else
					document.title += _.l(' - Free')

			$msg_box.modal('hide')

	init_revealjs: ->
		Reveal.initialize {
			controls: true
			progress: true
			history: true
			keyboard: true
			touch: true

			theme: Reveal.getQueryHash().theme
			transition: Reveal.getQueryHash().transition or 'default'

			dependencies: [
				{ src: '/reveal.js/plugin/highlight/highlight.js', async: true, callback: -> hljs.initHighlightingOnLoad() }
				{ src: '/reveal.js/plugin/zoom-js/zoom.js', async: true, condition: -> !!document.body.classList }
				{ src: '/reveal.js/plugin/notes/notes.js', async: true, condition: -> !!document.body.classList }
			]
		}

	init_host: ->
		@host = new NT.Host @socket

	init_guest: ->
		@guest = new NT.Guest @socket

	init_auto_refresh: ->
		@socket.on 'code_reload', (path) ->
			location.reload()
