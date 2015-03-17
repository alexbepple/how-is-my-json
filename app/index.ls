r = require('ramda')

JsonEditor = require('./jsonEditor/_.ls')
jsonEditor = JsonEditor('json')
schemaEditor = JsonEditor('schema')

summary = require('./summary/_.ls')()

highlighter = require('./visualizer/imjv-highlighter')
revalidate = ->
    bothInputsValid = jsonEditor.isValid() && schemaEditor.isValid()
    if bothInputsValid
        json = jsonEditor.getJson()
        schema = schemaEditor.getJson()
        highlighter.validateJsonAgainstSchema(json, schema, summary)
    else
        summary.showUnmetPreconditions()
    $('#validationResult').toggleClass('greyed-out', !bothInputsValid)


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
