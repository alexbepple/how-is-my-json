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
var validate = validator(schema);
validate(json);

var r = require('ramda');
var isWrongType = r.propEq('message', 'is the wrong type');
var fieldsWithWrongType = r.pluck('field')(r.filter(isWrongType, validate.errors));

var fieldToPathComponents = r.pipe(r.split('.'), r.tail, r.append('value'));
var prependString = r.useWith(r.replace(/^/), r.identity);
var pathComponentsToSelector = r.pipe(r.map(prependString('.')), r.join(' '));
var fieldToSelector = r.pipe(fieldToPathComponents, pathComponentsToSelector);

var selectorsForWrongType = r.map(fieldToSelector, fieldsWithWrongType);
console.log(selectorsForWrongType);

$(selectorsForWrongType[0]).addClass('validation-wrong-type');
$('.b .bb').addClass('validation-missing');
$('.b .bc').addClass('validation-additional');

