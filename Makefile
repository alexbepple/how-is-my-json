src := app/src
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



publish: prod
	$(foreman) run -e .env.publish make push-to-gh-pages

prod_build := build/prod
prod:
	rm -rf $(prod_build)
	$(bin)/brunch build --production
	# This is a workaround for browserify-brunch being broken for 'brunch build'
	$(bin)/browserify $(src)/main.js | $(bin)/uglifyjs -m -o $(prod_build)/app.js

push-to-gh-pages:
	woodhouse publish alexbepple/how-is-my-json $(prod_build): --auth-token $(GH_AUTH_TOKEN)
