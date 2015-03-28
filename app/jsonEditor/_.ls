r = require('ramda')
stripComments = require('strip-json-comments')
schemaEnhancer = require '../schema/schemaEnhancer.ls'

JsonEditor = (elementId) ->
    editor = document.getElementById(elementId)
    textarea = editor.getElementsByTagName('textarea')[0]
    $textarea = $(textarea)

    jsonToString = -> JSON.stringify(it, null, 4)
    parse = r.pipe(stripComments, JSON.parse)
    isValid = ->
        try
            getJson()
            return true
        catch
            return false

    onChange = -> textarea.addEventListener('input', it)

    emitChangeEvent = -> textarea.dispatchEvent new Event('input')

    _setString = -> textarea.value = it
    getString = -> textarea.value
    setString = ->
        _setString(it)
        emitChangeEvent()

    getJson = -> parse getString()
    setJson = -> setString jsonToString(it)

    highlightUnparseableJson = -> $textarea.toggleClass 'unparseable', !isValid()
    onChange highlightUnparseableJson


    onClick = (buttonSelector, onClick) ->
        $button = $(editor).find 'button.'+buttonSelector
        $button.bind 'click', onClick
        setButtonState = ->
            $button.prop 'disabled', !isValid()
        onChange setButtonState

    onClick 'reformat',
        r.pipe getJson, jsonToString, setString

    onClick 'prohibitAdditionalProps',
        r.pipe getJson, schemaEnhancer.prohibitAdditionalProperties, setJson

    {
        isValid
        onChange
        setString
        getString
        getJson
        setJson
    }

module.exports = JsonEditor
