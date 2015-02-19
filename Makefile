src := js
test := test

bin := $(shell npm bin)
run_tests := $(bin)/mocha --check-leaks --recursive $(test) --compilers ls:LiveScript

.PHONY: test
test:
	NODE_PATH=$(src) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(bin)/nodemon --exec 'make test' --ext ls,js


watchify:
	./node_modules/.bin/watchify js/main.js -o js/bundle.js

