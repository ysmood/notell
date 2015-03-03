process.chdir __dirname + '/..'
kit = require 'nokit'

app = kit.path.join process.cwd(), '/nobone.coffee'

switch process.argv[2]
	when 'setup'
		# Dependencies
		kit.spawn 'bower', ['--allow-root', 'install']

		# Configuration
		config_example = 'kit/config.example.coffee'
		ppt_example = 'kit/demo_ppt.example.ejs'
		if not kit.existsSync 'var/config.coffee'
			kit.copySync config_example, 'var/config.coffee'
			kit.log '>> Auto created an example config "var/config.coffee".'

			kit.copySync ppt_example, 'usr/demo_ppt.ejs'
			kit.log '>> Auto created a demo ppt at path "usr/demo_ppt.ejs"'

	when 'test'
		kit.spawn 'coffee', [app]

	when 'start'
		uptime_conf=''
		kit.spawn 'forever', [
			'--minUptime', '5000'
			'--spinSleepTime', '5000'
			'-a'
			'-o', 'var/log/std.log'
			'-e', 'var/log/err.log'
			'-c', 'node_modules/.bin/coffee'
			app
		]

	when 'stop'
		kit.spawn 'forever', ['stop', app]
