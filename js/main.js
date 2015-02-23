var schemaContainer = document.getElementById('schema');
var jsonContainer = document.getElementById('jsonToValidate');

var highlighter = require('./imjv-highlighter');
var revalidate = function () {
    var schema = JSON.parse(schemaContainer.value);
    var json = JSON.parse(jsonContainer.value);
    highlighter.validateJsonAgainstSchema(json, schema);
};

schemaContainer.addEventListener('input', revalidate);
jsonContainer.addEventListener('input', revalidate);

var schema = {
    type: 'object', 
    additionalProperties: false, 
    properties: {
        correct: {
            type: 'boolean', 
            required: true
        }, 
        shouldBeString: {
            type: 'string', 
            required: true
        }, 
        missing: { required: true }, 
        nestedObject: {
            type: 'object', 
            required: true,
            additionalProperties: false, 
            properties: {
                shouldBeNumber: {
                    type: 'number', 
                    required: true
                }, 
                missing: { required: true }
            }
        },
        arrayOfObjects: {
            type: 'array',
            required: true,
            items: {
                type: 'object',
                additionalProperties: false,
                properties: {
                    correct: { type: 'boolean' },
                    missing: { required: true }
                }
            }
        },
        arrayOfWhatShouldBeStrings: {
            type: 'array',
            items: { type: 'string' }
        }
    }
};
schemaContainer.textContent = JSON.stringify(schema, null, 4);
schemaContainer.dispatchEvent(new Event('input'));

jsonContainer.addEventListener('input', revalidate);
var json = {
    correct: true,
    additional: null,
    shouldBeString: 1,
    nestedObject: {
        shouldBeNumber: 'but is string', 
        additional: null
    },
    arrayOfObjects: [
        {correct: true, additional: null},
        {correct: true, additional: null}
    ],
    arrayOfWhatShouldBeStrings: [1, 2]
};
jsonContainer.textContent = JSON.stringify(json, null, 4);
jsonContainer.dispatchEvent(new Event('input'));
