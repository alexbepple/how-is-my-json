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
    type: 'object', 
    additionalProperties: false, 
    properties: {
        a: {
            type: 'string', 
            required: true
        }, 
        b: {
            type: 'object', 
            additionalProperties: false, 
            properties: {
                ba: {
                    type: 'integer', 
                    required: true
                }, 
                bb: {
                    type: 'string', 
                    required: true
                }
            }
        },
        c: {
            type: 'array',
            items: {
                type: 'object',
                additionalProperties: false,
                properties: {
                    a: { type: 'string' },
                    b: { type: 'string', required: true }
                }
            }
        },
        d: {
            type: 'array',
            items: { type: 'string' }
        }
    }
};
schemaContainer.textContent = JSON.stringify(schema, null, 4);
schemaContainer.dispatchEvent(new Event('input'));

jsonContainer.addEventListener('input', revalidate);
var json = {
    a: 'foo', 
    additional: 1,
    b: {
        ba: 'wrong type', 
        bc: 'additional'
    },
    c: [
        {a: 1, c: 2},
        {a: 3, c: 4}
    ],
    d: [1, 2]
};
jsonContainer.textContent = JSON.stringify(json, null, 4);
jsonContainer.dispatchEvent(new Event('input'));
