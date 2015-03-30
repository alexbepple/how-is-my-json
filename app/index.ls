r = require('ramda')

JsonEditor = require('./jsonEditor/_.ls')
jsonEditor = JsonEditor('json')
schemaEditor = JsonEditor('schema')

summary = require('./summary/_.ls')()
visualizer = require('./visualizer/_.ls')

revalidate = ->
    visualizer.clear()
    bothInputsValid = jsonEditor.isValid() && schemaEditor.isValid()
    unless bothInputsValid
        summary.showUnmetPreconditions()
        return

    try
        visualizer.validate(jsonEditor.getJson(), schemaEditor.getJson(), summary)
    catch
        summary.showExceptionDuringValidation()
        throw e

jsonEditor.onChange(revalidate)
schemaEditor.onChange(revalidate)


storeJson = -> localStorage.setItem('json', jsonEditor.getString())
storeSchema = -> localStorage.setItem('schema', schemaEditor.getString())

defaults = require('./defaults.ls')
loadUserContent = (key, jsonEditor, defaultAsObject) ->
    storedValue = localStorage.getItem(key)
    if (storedValue)
        jsonEditor.setString(storedValue)
    else
        jsonEditor.setJson(defaultAsObject)


loadUserContent('json', jsonEditor, defaults.json)
loadUserContent('schema', schemaEditor, defaults.schema)
jsonEditor.onChange(storeJson)
schemaEditor.onChange(storeSchema)
