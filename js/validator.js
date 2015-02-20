var validator = require('is-my-json-valid');
var r = require('ramda');

var addPathTo = function (object, path) {
    if (r.strIndexOf('*', path) === 0) {
        var pathInArrayElement = r.pipe(r.split('*.'), r.tail, r.join('*.'))(path);
        var addPath = r.flip(addPathTo);
        return r.map(addPath(pathInArrayElement))(object);
    }
    if (r.strIndexOf('*', path) > 0) {
        var pathsBetweenArrays = r.split('.*.')(path);
        var pathToArray = r.head(pathsBetweenArrays);
        var pathFromArrayOn = '*.' + r.pipe(r.tail, r.join('.*.'))(pathsBetweenArrays);
        var array = r.path(pathToArray, object);
        return r.assocPath(pathToArray, addPathTo(array, pathFromArrayOn), object);
    }
    return r.assocPath(path, '…', object);
};

var validateJsonAgainstSchema = function (json, schema) {
    var validate = validator(schema);
    validate(json);

    var errorToPathComponents = r.pipe(
        r.prop('field'), 
        r.split('.'), 
        r.tail);
    var prependString = r.useWith(r.replace(/^/), r.identity);
    var pathComponentsToSelector = r.pipe(r.map(prependString('.')), r.join(' '));

    var isWrongType = r.propEq('message', 'is the wrong type');
    var selectorsWrongType = r.pipe(
        r.filter(isWrongType),
        r.map(errorToPathComponents),
        r.map(pathComponentsToSelector),
        r.map(r.replace(/\*/g, 'array-element')),
        r.uniq
    )(validate.errors);

    var isMissing = r.propEq('message', 'is required');
    var selectorsMissing = r.pipe(
        r.filter(isMissing),
        r.map(errorToPathComponents),
        r.map(pathComponentsToSelector),
        r.map(r.replace(/\*/g, 'array-element'))
    )(validate.errors);

    var jsonWithMissingProperties = r.pipe(
        r.filter(isMissing),
        r.map(errorToPathComponents),
        r.map(r.join('.')), 
        r.reduce(addPathTo, json)
    )(validate.errors);

    var hasAdditionalProperties = r.propEq('message', 'has additional properties');
    var objectPathToSchemaPath = r.converge(
        r.pipe(
            r.zip,
            r.flatten,
            r.append('properties'),
            r.join('.')
        ),
        r.pipe(
            r.split('.'),
            r.length,
            r.times(r.identity),
            r.map(function(){return 'properties';})
        ),
        r.split('.')
    );
    var propertiesInSchemaUnderPath = r.pipe(
        objectPathToSchemaPath,
        r.flip(r.path)(schema),
        r.keys
    );
    var propertiesInObjectUnderPath = r.pipe(
        r.flip(r.path)(json),
        r.keys
    );
    var definedPaths = r.pipe(
        r.converge(
            r.xprod,
            r.of,
            propertiesInSchemaUnderPath
        ),
        r.map(r.join('.'))
    );
    var actualPaths = r.pipe(
        r.converge(
            r.xprod,
            r.of,
            propertiesInObjectUnderPath
        ),
        r.map(r.join('.'))
    );
    var pathsOfAdditionalPropertiesOf = r.converge(
        r.difference,
        actualPaths,
        definedPaths
    );

    var selectorsAdditional = r.pipe(
        r.filter(hasAdditionalProperties),
        r.map(errorToPathComponents),
        r.map(r.join('.')),
        r.map(pathsOfAdditionalPropertiesOf),
        r.flatten,
        r.map(r.split('.')),
        r.map(pathComponentsToSelector)
    )(validate.errors);


    var jsonToDom = require('./jsonToDom');
    var resultContainer = document.getElementById('validationResult');
    while (resultContainer.firstChild) {
        resultContainer.removeChild(resultContainer.firstChild);
    }
    resultContainer.appendChild(jsonToDom(jsonWithMissingProperties));

    $(r.join(',', selectorsWrongType)).addClass('validation-wrong-type');
    $(r.join(',', selectorsMissing)).addClass('validation-missing');
    $(r.join(',', selectorsAdditional)).addClass('validation-additional');
};

module.exports = {
    validateJsonAgainstSchema: validateJsonAgainstSchema,
    addPathTo: addPathTo
};

