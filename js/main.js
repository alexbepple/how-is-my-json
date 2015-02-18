var schemaContainer = document.getElementById('schema');
var jsonContainer = document.getElementById('jsonToValidate');

var validator = require('./validator');
var revalidate = function () {
    var schema = JSON.parse(schemaContainer.value);
    var json = JSON.parse(jsonContainer.value);
    validator.validateJsonAgainstSchema(json, schema);
};

schemaContainer.addEventListener('input', revalidate);
jsonContainer.addEventListener('input', revalidate);

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
schemaContainer.textContent = JSON.stringify(schema, null, 4);
schemaContainer.dispatchEvent(new Event('input'));

jsonContainer.addEventListener('input', revalidate);
var json = {
    "a": "foo", 
    "b": {
        "ba": "wrong type", 
        "bc": "additional"
    }
};
jsonContainer.textContent = JSON.stringify(json, null, 4);
jsonContainer.dispatchEvent(new Event('input'));
