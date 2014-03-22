default: clean build

build:
	mkdir -p build
	node_modules/coffee-script/bin/coffee -o build/ -c src/goggles.coffee
	node_modules/browserify/bin/cmd.js build/goggles.js -o build/goggles.main.js

clean:
	rm -rf build
