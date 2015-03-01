exports.config =
  files:
    javascripts:
      joinTo: 'app.js'
    stylesheets:
      joinTo: 'app.css'

  modules:
    definition: false

  plugins:
    browserify:
      bundles:
        'app.js':
          entry: 'app/src/main.js'
