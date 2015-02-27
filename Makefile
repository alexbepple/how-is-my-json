src := js
test := test

bin := $(shell npm bin)
run_tests := $(bin)/mocha --check-leaks --recursive $(test) --compilers ls:LiveScript
foreman := bundle exec foreman
browserify_arguments := js/main.js -o js/bundle.js

dev:
	$(foreman) start -f Procfile.dev

.PHONY: test
test:
	NODE_PATH=$(src) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(bin)/nodemon --exec 'make test' --ext ls,js --ignore js/bundle.js

watchify:
	$(bin)/watchify $(browserify_arguments)



publish: compile
	$(foreman) run -e .env.publish make push-to-gh-pages

compile:
	$(bin)/browserify $(browserify_arguments)

push-to-gh-pages:
	woodhouse publish alexbepple/how-is-my-json index.html:index.html css:css js/bundle.js:js/bundle.js --auth-token $(GH_AUTH_TOKEN)
