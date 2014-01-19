# Add new path to environment path
add-evn-path()
{
	PATH="$1:${PATH}"
	export PATH
}

add-evn-path "$(pwd)/node_modules/.bin"