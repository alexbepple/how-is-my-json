r = require('ramda')
stripComments = require('strip-json-comments')

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

    reformat = r.pipe getJson, jsonToString, setString
    reformatButton = $(editor).find '.button'
    enableReformatButton = ->
        reformatButton.toggleClass 'enabled', isValid()
        reformatButton.unbind 'click'
        if isValid()
            reformatButton.bind 'click', reformat

    onChange enableReformatButton

    {
        isValid
        onChange
        setString
        getString
        getJson
        setJson
    }

module.exports = JsonEditor
