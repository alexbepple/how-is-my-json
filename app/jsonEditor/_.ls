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

    markAsInvalid = -> $textarea.toggleClass 'invalid', !isValid()
    onChange markAsInvalid

    onClick = (buttonSelector, onClick) ->
        $button = $(editor).find 'button.'+buttonSelector
        $button.bind 'click', onClick
        setButtonState = ->
            $button.prop 'disabled', !isValid()
        onChange setButtonState

    onClick 'reformat',
        r.pipe getJson, jsonToString, setString

    {
        isValid
        onChange
        setString
        getString
        getJson
        setJson
        onClick
    }

module.exports = JsonEditor
