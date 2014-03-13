###
	The template engine of this project.
	@_ underscore
	@js auto create js html tag
	@css auto create css html tag
	@render render a ejs template.
###


class NB.Renderer
	constructor: ->
		@init_variables()
		@init_template_engine()

	init_variables: ->
		@locals = {
			# Global useful functions
			_: _
			render: @render
		}

	init_template_engine: ->
		@ejs = require 'ejs'
		@ejs.open = '<?'
		@ejs.close = '?>'
		@ejs.debug = (NB.conf.mode == 'development')

		# Set '<? ... ?>' like syntax.
		_.templateSettings =
			evaluate    : /<\?([\s\S]+?)\?>/g
			interpolate : /<\?=([\s\S]+?)\?>/g
			escape      : /<\?-([\s\S]+?)\?>/g

	render: (path, data = {}, raw = false) =>
		###
			The data arg must be an object.
		###

		data = _.clone(data)

		# Set global variables.
		_.safe_extend(data, @locals)

		code = _.get_cached_code(path)

		if raw
			return code
		else
			try
				rendered = @ejs.render(code, data)
				return rendered.toString()
			catch e
				return "<pre>#{_.escape(e)}</pre>"
