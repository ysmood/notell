class <%= class_name %> extends NB.Module
	constructor: ->
		super

		@name = @constructor.name.toLowerCase()

		@set_static_dir(@name + '/client', '/' + @name)

		NB.app.get '/', @home

	home: (req, res) =>
		# Load sections.
		data = {
			title: @name
			head: @r.render('assets/ejs/head.ejs')
			foot: @r.render('assets/ejs/foot.ejs')
			css: "/#{@name}/css/#{@name}.css"
			js: "/#{@name}/js/#{@name}.js"
		}

		# Render page.
		res.send @r.render("#{@name}/client/ejs/#{@name}.ejs", data)
