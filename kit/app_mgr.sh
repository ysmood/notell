coffee='node_modules/.bin/coffee'
forever='node_modules/.bin/forever'

app=$(pwd)/nobone.coffee

case $1 in
	'setup' )
		# Dependencies
			npm install
			node_modules/.bin/bower --allow-root install

		# Configuration
		config_example='kit/config.example.coffee'
		ppt_example='kit/demo_ppt.example.ejs'
		if [ ! -f config.coffee ]; then
			cp $config_example var/config.coffee
			echo '>> Auto created an example config "var/config.coffee".'

			cp $ppt_example usr/demo_ppt.ejs
			echo '>> Auto created a demo ppt at path "usr/demo_ppt.ejs"'
		fi
		;;

	'test' )
		$coffee --nodejs --debug $app
		;;

	'start' )
		uptime_conf='--minUptime 5000 --spinSleepTime 5000'
		log_conf='-a -o var/log/std.log -e var/log/err.log'
		$forever start $uptime_conf $log_conf -c $coffee $app
		;;

	'stop' )
		$forever stop $app
		;;
esac