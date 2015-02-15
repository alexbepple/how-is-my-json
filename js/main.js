var schema = {
    "type": "object", 
    "additionalProperties": false, 
    "properties": {
        "a": {
            "type": "string", 
            "required": true
        }, 
        "b": {
            "type": "object", 
            "additionalProperties": false, 
            "properties": {
                "ba": {
                    "type": "integer", 
                    "required": true
                }, 
                "bb": {
                    "type": "string", 
                    "required": true
                }
            }
        }
    }
};

var json = {
    "a": "foo", 
    "b": {
        "ba": "wrong type", 
        "bc": "additional"
    }
};

var validator = require('is-my-json-valid');
var validate = validator(schema, {verbose: true});
validate(json);

var r = require('ramda');

var errorToPathComponents = r.pipe(r.prop('field'), r.split('.'), r.tail);
var prependString = r.useWith(r.replace(/^/), r.identity);
var pathComponentsToSelector = r.pipe(r.map(prependString('.')), r.join(' '));

var isWrongType = r.propEq('message', 'is the wrong type');
var selectorsWrongType = r.pipe(
    r.filter(isWrongType),
    r.map(errorToPathComponents),
    r.map(r.append('value')),
    r.map(pathComponentsToSelector)
)(validate.errors);

var isMissing = r.propEq('message', 'is required');
var selectorsMissing = r.pipe(
    r.filter(isMissing),
    r.map(errorToPathComponents),
    r.map(pathComponentsToSelector)
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


$(r.join(',', selectorsWrongType)).addClass('validation-wrong-type');
$(r.join(',', selectorsMissing)).addClass('validation-missing');
$(r.join(',', selectorsAdditional)).addClass('validation-additional');

