# jQuery helpers

_.extend($.fn,

	transit_fade_in: (done, delay = 400) ->
		$this = this
		$this
			.show()
			.css({ opacity: 0 })
			.transit({ opacity: 1 }, delay, done)

	transit_fade_out: (done, delay = 400) ->
		$this = this
		$this.transit({ opacity: 0 }, delay, ->
			$this.hide()
			done?()
		)

	dragging: (options) ->
		_.defaults(options,
			data: {}
			mouse_down: (e) ->
			mouse_move: (e) ->
			mouse_up: (e) ->
			window: null #Useful when using in an iframe.
		)

		$target = this

		$html = $target.parents('html')

		mouse_down = (e) ->
			e.$target = $target
			e.data = options.data
			options.mouse_down(e)

			$html.mousemove(mouse_move)
			$html.one('mouseup', mouse_up)

		mouse_move = (e) ->
			e.$target = $target
			e.data = options.data
			options.mouse_move(e)

		mouse_up = (e)->
			e.$target = $target
			e.data = options.data
			options.mouse_up(e)

			# Release event resource.
			$html.off('mousemove', mouse_move)

		$target.mousedown(mouse_down)

	load_js: (elem, done) ->
		###
			done: ->

			We need to use the native way to create the script element,
			or the browser will not excute the script.
		###

		js = document.createElement("script")
		js.type = "text/javascript"
		if elem.src
			js.src = elem.src
			js.onload = done
			js.onerror = done
		else
			try
				js.appendChild(
					document.createTextNode(elem.text)
				)
			catch e
				js.text = elem.text
			done()

		this[0].appendChild(js)

	load_multi_js: ($js_list, all_done) ->
		$container = this
		_.sync_run_tasks(
			$js_list.map((el) -> (done, i) ->
					$container.load_js($js_list[i], done)
			)
			all_done
		)

	load_css: (elem, done) ->
		if elem.href
			css = document.createElement("link")
			css.setAttribute("rel", "stylesheet")
			css.setAttribute("type", "text/css")
			css.type = "text/css"
			css.href = elem.href
			css.onload = done
			css.onerror = done
		else
			css = document.createElement("style")
			if css.styleSheet
				css.styleSheet.cssText = elem.styleSheet.cssText
			else
				css.appendChild(
					document.createTextNode(
						$(elem).text()
					)
				)

		this[0].appendChild(css)

	load_multi_css: ($css_list, all_done) ->
		$container = this
		_.async_run_tasks(
			$css_list.map((el) -> (done, i) ->
				$container.load_css($css_list[i], done)
			)
			all_done
		)

	upload: (options) ->
		opts = _.defaults(options,
			url: ''
			dataType: 'json' #string, default is json
			done: ->
			progress: ->
		)

		this.each(->

			$this = $(this)
			form_data = new FormData()
			form_data.append($this.attr('name'), this.files[0])

			$.ajax({
				url: opts.url
				type: 'POST'
				dataType: opts.dataType
				xhr: ->
					xhr = $.ajaxSettings.xhr()
					xhr.upload.addEventListener('progress', opts.progress, false)
					return xhr
				data: form_data
				cache: false
				contentType: false
				processData: false
				complete: (res) ->
					data = res.responseText
					if opts.dataType == 'json'
						data = JSON.parse(data)

					opts.done?(data)
			})

		)

	dynamicList: (options) ->
		method 		= String(options)
		data_key 	= "dlist"
		init_key	= "dlistroot"
		events 		= {
			add: "dlist.add"
			del: "dlist.del"
			sort: "dlist.sort"
		}
		options = $.extend({
			add_sel: ".dlist-add"
			del_sel: ".dlist-del"
			list_sel: ".dlist-list"
			item_sel: ".dlist-item"
			init_one: false
		}, options)

		return this.each(->

			$root = $(this)
			$list = $root.find(options.list_sel)

			# process commands
			if "destroy" == method
				$root.off("click")
				return

			if "add" == method
				$root.find(options.add_sel)?.trigger("click")
				return

			# prevent double init
			if $root.data(init_key)
				return

			$root.data(init_key, true)

			# get the basic item
			$mock = $list.children().eq(-1)
			$mock.remove()

			# sortable
			get_sorted_index = ->
				ret = []
				$list.children().each( (i) ->
					ret.push($(this).data(data_key))
				)
				return ret

			set_natural_index = ->
				$list.children().each( (i) ->
					$(this).data(data_key, i)
				)

			reset_sortable = ->
				requirejs(['/html5sortable/jquery.sortable.js'], ->
					$list.sortable("destroy")
					$list.sortable()
				)

			$root.bind("sortupdate", ->
				$root.trigger(events.sort, [get_sorted_index()])
				set_natural_index()
			)

			# bind events on add / remove button
			$root.on("click", options.add_sel, ->
				$one = $mock.clone()

				$list.append($one)
				set_natural_index()
				reset_sortable()
				$root.trigger(events.add, [$one])

				return false
			)

			$root.on("click", options.del_sel, ->
				$item = $(this).parents(options.item_sel).eq?(0)

				if $item?
					index = $item.data(data_key)
					$item.remove()
					set_natural_index()
					reset_sortable()
					$root.trigger(events.del, [index])

				return false
			)

			set_natural_index()
			reset_sortable()
		)

	sort_by_top_offset: ->
		list = _.sortBy(this, (el) -> $(el).offset().top)
		this.parent().append(list)

	bound: ->
		pos = this.position()

		bound = {
			right: pos.left + this.width()
			bottom: pos.top + this.height()
		}
		_.extend(bound, pos)

	collision: (elems, iter) ->
		if not this.length
			return []
		$area = this
		area = $area.bound()

		is_collision = ($el) ->
			if not $el.length
				return false
			rect = $el.bound()
			not (
				area.right < rect.left or
				area.bottom < rect.top or
				rect.right < area.left or
				rect.bottom < area.top
			)
		res = []
		for el in elems
			res.push el if is_collision(iter(el))
		return res

)
