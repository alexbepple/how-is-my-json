require! {
    ramda: r
    'strip-json-comments': stripComments
}

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

    onClick = (buttonSelector, onClick) ->
        $button = $(editor).find 'button.'+buttonSelector
        $button.bind 'click', onClick
        setButtonState = ->
            $button.prop 'disabled', !isValid()
        onChange setButtonState

    that = {
        isValid
        onChange
        setString
        getString
        getJson
        setJson
        onClick
    }

    onClick 'reformat',
        r.pipe getJson, jsonToString, setString

    markAsInvalid = -> $textarea.toggleClass 'invalid', !that.isValid()
    onChange markAsInvalid

    that

module.exports = JsonEditor
