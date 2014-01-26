#! node_modules/.bin/coffee

fs = require 'fs-extra'
_ = require 'underscore'

if not process.argv[2]
	console.log 'Usage: make_module Namespace.Class_name'
	return

[namespace, class_name] = process.argv[2].split('.')

pname = class_name.toLowerCase()

if fs.existsSync(pname)
	fs.removeSync(pname)

fs.copySync('kit/module_tpl', pname)

fs.renameSync(
	pname + '/client/css/module_tpl.styl'
	pname + "/client/css/#{pname}.styl"
)
fs.renameSync(
	pname + '/client/js/module_tpl.coffee'
	pname + "/client/js/#{pname}.coffee"
)
fs.renameSync(
	pname + '/client/ejs/module_tpl.ejs'
	pname + "/client/ejs/#{pname}.ejs"
)
fs.renameSync(
	pname + '/module_tpl.coffee'
	pname + "/#{pname}.coffee"
)

src = fs.readFileSync(pname + "/#{pname}.coffee", 'utf8')
code = _.template(src, { class_name: process.argv[2] })
fs.writeFileSync(pname + "/#{pname}.coffee", code)

console.log '>> Module created: ' + process.argv[2]
