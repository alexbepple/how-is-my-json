app := app
build ?= build/dev
prod_build := build/prod

bin := node_modules/.bin
foreman := bundle exec foreman
nodemon := $(bin)/nodemon


dev: build-clean build-folder
	$(foreman) start -f Procfile.dev

publish: prod
	$(foreman) run -e .env.publish make push-to-gh-pages
prod:
	build=$(prod_build) make build js-uglify
push-to-gh-pages:
	woodhouse publish alexbepple/how-is-my-json $(prod_build): --auth-token $(GH_AUTH_TOKEN)


build-clean:
	rm -rf $(build)
build-folder:
	mkdir -p $(build)
build: build-clean build-folder assets css js


css := $(app)/css
css_bundle := $(build)/app.css
css:
	$(bin)/cleancss $(css)/*.css -o $(css_bundle)
	$(bin)/autoprefixer $(css_bundle)
css-continuously:
	$(nodemon) --exec 'make css' --watch $(css) --ext css


src := $(app)/src
assets := $(app)/assets
assets:
	cp -R $(assets)/* $(build)
assets-continuously:
	$(nodemon) --exec 'make assets' --watch $(assets) --ext '*'


js_bundle := $(build)/app.js
js:
	$(bin)/browserify $(src)/main.js -o $(js_bundle)
js-uglify:
	$(bin)/uglifyjs $(js_bundle) -o $(js_bundle) --mangle
js-continuously:
	$(nodemon) --exec 'make js' --watch $(src) --ext js


test := test
run_tests := $(bin)/mocha --check-leaks --recursive $(test) --compilers ls:LiveScript
.PHONY: test
test:
	NODE_PATH=$(src) $(run_tests) --reporter mocha-unfunk-reporter $(args)
tdd:
	$(nodemon) --exec 'make test' --watch $(src) --watch $(test) --ext ls,js
