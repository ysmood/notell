NB.conf = {

	port: 8013

	enable_socket_io: false

	modules: {
		'NB.Database': './sys/database'
		'NB.Storage': './sys/storage'
		'NB.Plugin': './sys/plugin'
		'NB.Api': './sys/api'
	}

	db_filename: 'var/NB.db'

	load_langs: ['en']

	current_lang: ['en']

	mode: 'development'

}
