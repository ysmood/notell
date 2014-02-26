

# Dump error information.
_.mixin

	sandbox: (func, err_msg) ->
		try
			func()
		catch e
			console.error "\u0007\n" # Bell sound
			console.error """>> #{err_msg}
				>> #{e}
				>> Stack: #{e.stack}
			""".c('red')
			if e.location
				console.error JSON.stringify(e, null, 4).c('red')
			console.error "<<".c('red')

	safe_extend: (objs...) ->
		###
			Check if list of objects have same named properties.
		###

		key_arrs = ( _.keys(arr) for arr in objs )

		inter = _.intersection.apply(_, key_arrs)

		if inter.length > 0
			throw ('Some properties are same named: ' + inter).red
		else
			return _.extend.apply(_, objs)

	node_version: ->
		###
			Return a int represent the version of node.
		###

		arr = process.version.slice(1).split('.')
		v = +arr[0] * 10000 + +arr[1] * 100 + +arr[2]
		return v

	find_route: (routes, req) ->
		###
			Traverse through the express's routes, return the route which matches
			the given path.
		###

		for verb, list of routes
			for route in list
				if route.regexp.test(req.path) and
				route.method == req.method
					return route

		return null

	get_cached_code: (path, compiler) ->
		###
			compiler: (str) ->
				return the compiled code.
		###

		NB.code_cache_pool ?= {}

		if NB.code_cache_pool[path] != undefined
			return NB.code_cache_pool[path]

		get_code = =>
			_.sandbox(
				->
					fs = require 'fs-extra'
					str = fs.readFileSync(path, 'utf8')

					is_first_load = !NB.code_cache_pool[path]

					if compiler
						NB.code_cache_pool[path] = compiler str, path
					else
						NB.code_cache_pool[path] = str

					t = (new Date).toLocaleTimeString()

					if is_first_load
						console.log (">> #{t} Watch: " + path).c('green')
					else
						NB.nobone.emitter.emit 'code_reload', path

						console.log (">> #{t} Reload: " + path).c('green')
				"Load error: " + path
			)

		get_code()

		if NB.conf.mode != 'product'
			Gaze = require 'gaze'

			gaze = new Gaze(path)
			gaze.on('changed', get_code)
			gaze.on('deleted', =>
				delete NB.code_cache_pool[path]
				gaze.remove(path)
				console.log ">> Watch removed: #{path}".c('yellow')
			)

			console.log ('>> Watch: ' + path).c('blue')

		return NB.code_cache_pool[path]

	sync_run_tasks: (tasks, all_done) ->
		i = 0

		check = ->
			if i < tasks.length
				run()
			else
				all_done()

		run = ->
			tasks[i](check, i)
			i++

		check()

	async_run_tasks: (tasks, all_done) ->
		count = 0

		check = ->
			if count < _.keys(tasks).length
				count++
			else
				all_done?()

		check()

		_.each(tasks, (task, k) ->
			task(check, k)
		)

	walk_files: (root, iterator) ->
		###
			iterator: (root+filename, filename) ->
		###

		fs = require 'fs-extra'

		f_list = fs.readdirSync(root)

		for f in f_list
			path = root + '/' + f
			if not fs.lstatSync(path).isFile() or
			f[0] != '.'
				iterator(path, f)

		return

	walk_dirs: (root, iterator) ->
		###
			iterator: (root+dir, dir) ->
		###

		fs = require 'fs-extra'

		dir_list = fs.readdirSync(root)

		for dir in dir_list
			path = root + '/' + dir
			if fs.lstatSync(path).isDirectory() or
			dir[0] != '.'
				iterator path, dir

	l: (english) ->
		###
			Translate English to current language.
		###

		str = NB.langs[NB.conf.current_lang][english]
		return str or english

	js: (list) =>
		# e.g. js('main.js', 'others.js', ...)
		if list instanceof Array
			arr = list
		else
			arr = arguments

		out = ''
		for path in arr
			out += "<script type='text/javascript' src='#{path}'></script>"

		return out

	css: (list) =>
		# e.g. css('main.css', 'others.css', ...)
		if list instanceof Array
			arr = list
		else
			arr = arguments

		out = ''
		for path in arr
			out += "<link rel='stylesheet' type='text/css' href='#{path}' />"

		return out


# Other helpers

	# String color getter only works on none-product mode.
	String.prototype.c = (color) ->
		if NB.conf.mode != 'product'
			return this[color]
		else
			return this + ''
