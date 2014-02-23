NB.conf = {

	port: 8013

	enable_socket_io: false

	modules: {
		'NB.Database': './sys/modules/database'
		'NB.Storage': './sys/modules/storage'
		'NB.Api': './sys/modules/api'
	}

	db_filename: 'var/NB.db'

	load_langs: ['en', 'cn']

	current_lang: ['cn']

	mode: 'development'

}
