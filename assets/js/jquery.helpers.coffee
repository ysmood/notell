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

)
