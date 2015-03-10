var r = require('ramda');
var m = require('./misc');

var pathsOfAdditionalProperties = r.curry(function (findActual, findDefined, path) {
    var additionalProps = r.converge(
        r.difference, findActual, findDefined
    )(path);
    return r.map(m.prependPath(path))(additionalProps);
});

var propertiesInObject = r.curry(function (object, path) {
    var safePath = r.ifElse(r.isEmpty, r.always(object), r.flip(r.path)(object));
    return r.pipe(
        r.replace(/\*/g, '0'),
        safePath,
        r.keys
    )(path);
});
var objectPathToSchemaPath = function (objectPath) {
    if (objectPath === '')
        return 'properties';
    return r.pipe(
        r.split('.'),
        r.map(m.appendStr('.properties')),
        r.prepend('properties'),
        r.join('.'),
        r.replace(/properties\.\*/g, 'items')
    )(objectPath);
};
var propertiesInSchema = r.useWith(propertiesInObject, r.identity, objectPathToSchemaPath);
var selectorsForAdditionalProperties = function (schema, json, errors) {
    var hasAdditionalProperties = r.propEq('message', 'has additional properties');
    var excessSubpaths = pathsOfAdditionalProperties(
        propertiesInObject(json),
        propertiesInSchema(schema)
    );
    return r.pipe(
        r.filter(hasAdditionalProperties),
        r.map(m.errorToPathComponents),
        r.map(r.join('.')),
        r.map(excessSubpaths),
        r.flatten,
        r.map(r.split('.')),
        r.map(m.pathComponentsToSelector),
        r.uniq
    )(errors);
};

module.exports = {
    selectorsForAdditionalProperties: selectorsForAdditionalProperties,
    propertiesInObject: propertiesInObject,
    objectPathToSchemaPath: objectPathToSchemaPath,
    pathsOfAdditionalProperties: pathsOfAdditionalProperties
};
