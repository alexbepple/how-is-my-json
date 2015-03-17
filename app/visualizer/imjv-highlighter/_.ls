require! {
    'is-my-json-valid': validator
    ramda: r
    './misc.ls': m
    './additional.ls': additional
    '../jsonToDom.ls': jsonToDom
}
addPathTo = require('./missing.ls').addPathTo

removeAllChildren = (node) ->
    while (node.firstChild)
        node.removeChild(node.firstChild)

displayJson = (json) ->
    resultContainer = document.getElementById 'validationResult'
    removeAllChildren resultContainer
    resultContainer.appendChild jsonToDom(json)

validateJsonAgainstSchema = (json, schema, summary) ->
    validate = validator schema
    isValid = validate json

    if isValid
        summary.showValid()
        displayJson json
        return

    isWrongType = r.propEq 'message', 'is the wrong type'
    selectorsWrongType = r.pipe(
        r.filter(isWrongType)
        m.errorsToSelectors
    )(validate.errors)

    isMissing = r.propEq 'message', 'is required'
    selectorsMissing = r.pipe(
        r.filter(isMissing)
        m.errorsToSelectors
    )(validate.errors)

    jsonWithMissingProperties = r.pipe(
        r.filter(isMissing)
        r.map(m.errorToPathComponents)
        r.map(r.join('.'))
        r.reduce(addPathTo, json)
    )(validate.errors)

    displayJson jsonWithMissingProperties

    addClass = (cssClass, selectors) ->
        $(r.join(',', selectors)).addClass(cssClass)

    selectorsAdditional = additional
        .selectorsForAdditionalProperties(schema, json, validate.errors)

    addClass 'validation-wrong-type', selectorsWrongType
    addClass 'validation-missing', selectorsMissing
    addClass 'validation-additional', selectorsAdditional

    summary.showInvalid(
        wrong: selectorsWrongType.length
        missing: selectorsMissing.length
        additional: selectorsAdditional.length
    )

module.exports = {
    validateJsonAgainstSchema
}
