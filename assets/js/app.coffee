class NB.App
	constructor: ->
		@init_global_tooltip()
		@init_global_effect()

	init_global_tooltip: ->
		$('body').on('mouseenter', '[title]', ->
			$this = $(this)
			$this.tooltip(
				container: 'body'
				placement: 'auto'
				animation: false
			)
			$this.tooltip('show').removeAttr('title')
		)

	init_global_effect: ->
		$('body').on(
			'mouseenter'
			'a, .button, .btn, .view_mode, [xtool], [tool], .tool-group-tabs .tab'
			->
				_.play_audio('/audio/ta.mp3')
		)
