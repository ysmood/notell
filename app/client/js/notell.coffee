
class NT.Notell
	constructor: ->
		@init_revealjs()

		Reveal.addEventListener 'ready', @init_role

	init_role: =>
		self = @

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