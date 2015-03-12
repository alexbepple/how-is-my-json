app := app
env ?= dev
build ?= build/dev
prod_build := build/prod

bin := node_modules/.bin
foreman := bundle exec foreman
nodemon := $(bin)/nodemon


dev: build
	ln -s ../../bower_components $(build)/bower
	$(foreman) start -f Procfile.dev
port := 3333
reload-live:
	$(bin)/livereloadx -s -p $(port) $(build) > /dev/null

publish: prod
	$(foreman) run -e .env.publish make push-to-gh-pages
prod:
	env=prod build=$(prod_build) make build js-uglify
push-to-gh-pages:
	woodhouse publish alexbepple/how-is-my-json $(prod_build): --auth-token $(GH_AUTH_TOKEN)


build-clean:
	rm -rf $(build)
build-folder:
	mkdir -p $(build)
build: build-clean build-folder html css js


html:
	$(bin)/jade app/html/index.jade --obj env/$(env).json --pretty --out $(build) $(args)
html-continuously:
	make html args='--watch'

css := $(app)/css
css_bundle := $(build)/app.css
css:
	$(bin)/node-sass $(css)/index.scss --stdout | $(bin)/cleancss -o $(css_bundle)
	$(bin)/autoprefixer $(css_bundle)
css-continuously:
	$(nodemon) --exec 'make css' --watch $(css) --ext scss


src := $(app)/src
js_bundle := $(build)/app.js
js:
	$(bin)/browserify -t liveify $(src)/index.js -o $(js_bundle)
js-uglify:
	$(bin)/uglifyjs $(js_bundle) -o $(js_bundle) --mangle
js-continuously:
	$(nodemon) --exec 'make js' --watch $(src) --ext ls,js


test := test
run_tests := $(bin)/mocha --check-leaks --recursive $(test) --compilers ls:LiveScript
.PHONY: test
test:
	NODE_PATH=$(src) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(nodemon) --exec 'make test' --watch $(src) --watch $(test) --ext ls,js
