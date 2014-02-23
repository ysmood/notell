class NB.Nobone
	constructor: ->
		@init_underscore()
		@init_langs()
		@init_global_tooltip()
		@init_global_effect()

	init_underscore: ->
		_.mixin _.str.exports()
		_.str.include 'Underscore.string', 'string'

		_.templateSettings = {
			evaluate    : /<\?([\s\S]+?)\?>/g
			interpolate : /<\?=([\s\S]+?)\?>/g
			escape      : /<\?-([\s\S]+?)\?>/g
		}

	init_langs: ->

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
