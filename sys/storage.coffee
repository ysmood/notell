fs = require 'fs-extra'


class NB.Storage extends NB.Module
	constructor: ->
		super

		NB.app.post('/upload/:dir', @upload)

	upload: (req, res) =>
		###
			In request form, the file input's name attribute
			must be `file`.
			The last segment of the request url will define
			the final store location of a file.
		###

		formidable = require 'formidable'

		form = new formidable.IncomingForm()
		form.uploadDir = 'var/tmp'
		form.keepExtensions = true

		form.parse req, (err, fields, files) ->
			{
				name: origin_name
				path: tmp_path
			} = files.file

			dir = 'usr/' + req.params.dir
			path = dir + '/' + origin_name

			if not fs.existsSync(dir)
				fs.mkdirSync(dir)

			fs.renameSync(tmp_path, path)

			res.send
				url: '/' + path
				name: origin_name
