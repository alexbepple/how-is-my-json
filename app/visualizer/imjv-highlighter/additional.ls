r = require('ramda')
m = require('./misc.ls')

pathsOfAdditionalProperties = (findActual, findDefined, path) -->
    additionalProps = r.converge(
        r.difference, findActual, findDefined
    )(path)
    r.map(m.prependPath(path))(additionalProps)

propertiesInObject = (object, path) -->
    safePath = r.ifElse(r.isEmpty, r.always(object), r.flip(r.path)(object))
    return r.pipe(
        r.replace(/\*/g, '0')
        safePath
        r.keys
    )(path)

objectPathToSchemaPath = (objectPath) ->
    if (objectPath === '')
        return 'properties'
    r.pipe(
        m.pathToComponents
        r.map(m.appendStr('.properties'))
        r.prepend('properties')
        m.componentsToPath
        r.replace(/properties\.\*/g, 'items')
    )(objectPath)

propertiesInSchema = r.useWith(
    propertiesInObject, r.identity, objectPathToSchemaPath)

selectors = (schema, json, errors) ->
    hasAdditionalProperties = r.propEq 'message', 'has additional properties'
    additionalSubpaths = pathsOfAdditionalProperties(
        propertiesInObject json
        propertiesInSchema schema
    )
    r.pipe(
        r.filter(hasAdditionalProperties)
        r.map(m.errorToPath)
        r.map(additionalSubpaths)
        r.flatten
        r.map(m.pathToSelector)
        r.uniq
    )(errors)

module.exports = {
    selectors
    propertiesInObject
    objectPathToSchemaPath
    pathsOfAdditionalProperties
}
