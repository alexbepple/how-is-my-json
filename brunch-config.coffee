exports.config =
  files:
    javascripts:
      joinTo: 'app.js'
    stylesheets:
      joinTo: 'app.css'

  plugins:
    browserify:
      bundles:
        'app.js':
          entry: 'app/src/main.js'
