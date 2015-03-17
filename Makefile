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

go: prod test
	git add -A :/ && git commit --verbose


build-clean:
	rm -rf $(build)
build-folder:
	mkdir -p $(build)
build: build-clean build-folder html css js


html:
	$(bin)/jade $(app)/index.jade --obj env/$(env).json --pretty --out $(build) $(args)
html-continuously:
	make html args='--watch'

css_bundle := $(build)/app.css
css:
	$(bin)/node-sass $(app)/index.scss --stdout | $(bin)/cleancss -o $(css_bundle)
	$(bin)/autoprefixer $(css_bundle)
css-continuously:
	$(nodemon) --exec 'make css' --watch $(app) --ext scss


js_bundle := $(build)/app.js
js:
	$(bin)/browserify -t liveify $(app)/index.ls -o $(js_bundle)
js-uglify:
	$(bin)/uglifyjs $(js_bundle) -o $(js_bundle) --mangle
js-continuously:
	$(nodemon) --exec 'make js' --watch $(app) --ext ls,js


run_tests := $(bin)/mocha --check-leaks --compilers ls:LiveScript app/**/*_spec.ls
.PHONY: test
test:
	NODE_PATH=$(app) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(nodemon) --exec 'make test' --watch $(app) --ext ls,js
