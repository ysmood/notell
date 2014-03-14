NB.conf = {

	port: 8013

	enable_socket_io: true

	modules: {
		'NT.App': './app/app'
	}

	db_filename: 'var/NB.db'

	load_langs: ['en']

	current_lang: ['en']

	mode: 'development'

	token: 'abc'

	default: 'app/client/ejs/reveal.ejs'

}
