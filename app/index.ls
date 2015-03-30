r = require('ramda')

JsonEditor = require('./jsonEditor/_.ls')
jsonEditor = JsonEditor('json')
schemaEditor = JsonEditor('schema')

summary = require('./summary/_.ls')()

highlighter = require('./visualizer/imjv-highlighter/_.ls')
revalidate = ->
    bothInputsValid = jsonEditor.isValid() && schemaEditor.isValid()
    $('#validationResult').addClass('greyed-out')
    unless bothInputsValid
        summary.showUnmetPreconditions()
        return

    json = jsonEditor.getJson()
    schema = schemaEditor.getJson()
    try
        highlighter.validateJsonAgainstSchema(json, schema, summary)
        $('#validationResult').removeClass('greyed-out')
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
