default: clean build

build: clean
	mkdir -p build
	node_modules/coffee-script/bin/coffee -o build/ -c src/goggles.coffee
	node_modules/browserify/bin/cmd.js build/goggles.js --standalone Goggles -o build/goggles.main.js

compress: build
	cp build/goggles.main.js goggles.js
	node_modules/.bin/uglifyjs build/goggles.main.js > goggles.min.js
	mv build/goggles.main.js build/goggles.js

test: build
	npm test

clean:
	rm -rf build

.PHONY: clean build compress test
