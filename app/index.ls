r = require('ramda')
JsonEditor = require('./jsonEditor/_.ls')
SchemaEditor = require('./schemaEditor/_.ls')

jsonEditor = JsonEditor('json')
schemaEditor = SchemaEditor('schema')

summary = require('./summary/_.ls')()
visualizer = require('./visualizer/_.ls')

revalidate = ->
    visualizer.clear()
    unless jsonEditor.isValid()
        summary.showError 'Fix the JSON to be checked.'
        return
    unless schemaEditor.isJsonValid()
        summary.showError 'Fix the JSON for the schema.'
        return
    unless schemaEditor.isSchemaValid()
        summary.showError 'The schema is invalid. Fix it.'
        return

    try
        visualizer.validate(jsonEditor.getJson(), schemaEditor.getJson(), summary)
    catch
        summary.showError 'Cannot validate. Check the console.'
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
