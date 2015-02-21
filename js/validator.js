var validator = require('is-my-json-valid');
var r = require('ramda');

var errorToPathComponents = r.pipe(
    r.prop('field'), 
    r.split('.'), 
    r.tail);
var prependString = r.useWith(r.replace(/^/), r.identity);
var pathComponentsToSelector = r.pipe(
    r.map(prependString('.')), 
    r.join(' '),
    r.replace(/\*/g, 'array-element')
);
var errorsToSelectors = r.pipe(
    r.map(errorToPathComponents),
    r.map(pathComponentsToSelector),
    r.uniq
);

var dropLastChar = r.pipe(r.split(''), r.init, r.join(''));
var addPathTo = function (object, path) {
    var pathSegments = r.split('*.', path);

    if (r.length(pathSegments) === 1)
        return r.assocPath(path, '…', object);

    var pathInArrayElement = r.pipe(r.tail, r.join('*.'))(pathSegments);
    if (Array.isArray(object)) {
        return r.map(addPath(pathInArrayElement))(object);
    }

    var pathToArray = r.pipe(r.head, dropLastChar)(pathSegments);
    var pathFromArrayOn = '*.' + pathInArrayElement;
    var augmentedArray = addPathTo(r.path(pathToArray, object), pathFromArrayOn);
    return r.assocPath(pathToArray, augmentedArray, object);
};
var addPath = r.flip(addPathTo);


var selectorsForAdditionalProperties = function (schema, json, errors) {
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
    return r.pipe(
        r.filter(hasAdditionalProperties),
        r.map(errorToPathComponents),
        r.map(r.join('.')),
        r.map(pathsOfAdditionalPropertiesOf),
        r.flatten,
        r.map(r.split('.')),
        r.map(pathComponentsToSelector)
    )(errors);
};


var validateJsonAgainstSchema = function (json, schema) {
    var validate = validator(schema);
    validate(json);

    var isWrongType = r.propEq('message', 'is the wrong type');
    var selectorsWrongType = r.pipe(
        r.filter(isWrongType),
        errorsToSelectors
    )(validate.errors);

    var isMissing = r.propEq('message', 'is required');
    var selectorsMissing = r.pipe(
        r.filter(isMissing),
        errorsToSelectors
    )(validate.errors);

    var jsonWithMissingProperties = r.pipe(
        r.filter(isMissing),
        r.map(errorToPathComponents),
        r.map(r.join('.')), 
        r.reduce(addPathTo, json)
    )(validate.errors);

    var jsonToDom = require('./jsonToDom');
    var resultContainer = document.getElementById('validationResult');
    while (resultContainer.firstChild) {
        resultContainer.removeChild(resultContainer.firstChild);
    }
    resultContainer.appendChild(jsonToDom(jsonWithMissingProperties));

    var addClass = function (cssClass, selectors) {
        $(r.join(',', selectors)).addClass(cssClass);
    };
    addClass('validation-wrong-type', selectorsWrongType);
    addClass('validation-missing', selectorsMissing);
    addClass('validation-additional', 
             selectorsForAdditionalProperties(schema, json, validate.errors));

};

module.exports = {
    validateJsonAgainstSchema: validateJsonAgainstSchema,
    addPathTo: addPathTo,
    selectorsForAdditionalProperties: selectorsForAdditionalProperties
};

