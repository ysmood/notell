###
	The template engine of this project.
	@_ underscore
	@js auto create js html tag
	@css auto create css html tag
	@render render a ejs template.
###


class NB.Renderer
	constructor: (@root = '') ->
		@init_variables()
		@init_template_engine()

	init_variables: ->
		@extension = '.ejs'

		@locals = {
			# Global useful functions
			_: _
			js: @js
			css: @css
			render: @render
		}

	init_template_engine: ->
		# Set '<? ... ?>' like syntax.
		_.templateSettings =
			evaluate    : /<\?([\s\S]+?)\?>/g
			interpolate : /<\?=([\s\S]+?)\?>/g
			escape      : /<\?-([\s\S]+?)\?>/g

	render: (path, data = {}, raw = false, auto_extension = true) =>
		###
			The data arg must be an object.
			If the path begins with '/',  will use a relative path to
			this project's assets directory, else it will use the component's directory.
		###

		data = _.clone(data)

		if _.startsWith(path, '/')
			real_path = _.ltrim(path, '/')
		else
			real_path = @root + '/' + path

		if auto_extension
			real_path += @extension

		# Set global variables.
		_.safe_extend(data, @locals)

		code = _.get_cached_code(real_path)

		if raw
			return code
		else
			try
				rendered = _.template(code, data)
				return rendered.toString()
			catch e
				return "<pre>#{e.stack}</pre>"

	# e.g. js('main.js', 'others.js', ...)
	js: =>
		out = ''
		for path in arguments
			if _.startsWith(path, '/')
				real_path = path
			else
				real_path = "/#{@root}/js/#{path}"

			out += "<script src='#{real_path}.js'></script>"

		return out

	# e.g. css('main.css', 'others.css', ...)
	css: =>
		out = ''
		for path in arguments
			if _.startsWith(path, '/')
				real_path = path
			else
				real_path = "/#{@root}/css/#{path}"

			out += "<link rel='stylesheet' type='text/css' href='#{real_path}.css' />"

		return out
