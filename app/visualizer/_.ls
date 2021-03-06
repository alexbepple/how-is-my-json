require! {
    'is-my-json-valid': validator
    ramda: r
    './imjv-highlighter/wrongType.ls': wrongType
    './imjv-highlighter/missing.ls': missing
    './imjv-highlighter/additional.ls': additional
    './jsonToDom.ls': jsonToDom
}

removeAllChildren = (node) ->
    while (node.firstChild)
        node.removeChild(node.firstChild)

displayJson = (json) ->
    resultContainer = document.getElementById 'validationResult'
    removeAllChildren resultContainer
    resultContainer.appendChild jsonToDom(json)
    showResult()

clear = -> $('#validationResult').addClass('greyed-out')
showResult = -> $('#validationResult').removeClass('greyed-out')

addClass = (cssClass, selectors) ->
    $(r.join(',', selectors)).addClass(cssClass)

validate = (json, schema, summary) ->
    validate = validator schema
    isValid = validate json

    if isValid
        summary.showValid()
        displayJson json
        return

    displayJson missing.addPropertiesTo(json, validate.errors)

    selectorsWrongType = wrongType.selectors validate.errors
    selectorsMissing = missing.selectors validate.errors
    selectorsAdditional = additional.selectors schema, json, validate.errors

    addClass 'validation-wrong-type', selectorsWrongType
    addClass 'validation-missing', selectorsMissing
    addClass 'validation-additional', selectorsAdditional

    summary.showInvalid(
        wrong: selectorsWrongType.length
        missing: selectorsMissing.length
        additional: selectorsAdditional.length
    )

module.exports = {
    validate
    clear
}
