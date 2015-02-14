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
                "baa": {
                    "type": "boolean", 
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
        "baa": "string instead of boolean",
        "bc": "additional"
    }
};

var validator = require('is-my-json-valid');
var validate = validator(schema);
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


$(r.join(',', selectorsWrongType)).addClass('validation-wrong-type');
$(r.join(',', selectorsMissing)).addClass('validation-missing');
$('.b .bc').addClass('validation-additional');

