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


var util = require('util');
var validator = require('./validator');

var jsonContainer = document.getElementById('jsonToValidate');
jsonContainer.addEventListener('input', function () {
    var json = JSON.parse(jsonContainer.value);
    console.log(util.format('JSON changed to: %s', util.inspect(json)));
    validator.validateJsonAgainstSchema(json, schema);
});
var json = {
    "a": "foo", 
    "b": {
        "ba": "wrong type", 
        "bc": "additional"
    }
};
jsonContainer.textContent = JSON.stringify(json, null, 4);
jsonContainer.dispatchEvent(new Event('input'));
