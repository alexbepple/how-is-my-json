src := app/js
test := test

bin := $(shell npm bin)
run_tests := $(bin)/mocha --check-leaks --recursive $(test) --compilers ls:LiveScript
foreman := bundle exec foreman

dev:
	$(foreman) start -f Procfile.dev

.PHONY: test
test:
	NODE_PATH=$(src) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(bin)/nodemon --exec 'make test' --watch $(src) --watch $(test) --ext ls,js

build-for-dev-continuously:
	$(bin)/brunch watch --server



publish: build-for-production
	$(foreman) run -e .env.publish make push-to-gh-pages

build-for-production:
	rm -rf public
	$(bin)/brunch build --production
	# This is a workaround for browserify-brunch being broken for 'brunch build'
	$(bin)/browserify app/init.js | $(bin)/uglifyjs -m -o public/app.js

push-to-gh-pages:
	woodhouse publish alexbepple/how-is-my-json public: --auth-token $(GH_AUTH_TOKEN)
