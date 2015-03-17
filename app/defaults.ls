exports.json =
    correct: true
    additional: null
    shouldBeString: 1
    nestedObject:
        shouldBeNumber: 'but is string'
        additional: null
    arrayOfObjects:
        * correct: true, additional: null, shouldBeBoolean: null
        * correct: true, additional: null, shouldBeBoolean: null
    arrayOfWhatShouldBeStrings: [1, 2]

exports.schema =
    type: 'object'
    additionalProperties: false
    properties:
        correct:
            type: 'boolean'
            required: true
        shouldBeString:
            type: 'string'
            required: true
        missing: required: true
        nestedObject:
            type: 'object'
            required: true
            additionalProperties: false
            properties:
                shouldBeNumber:
                    type: 'number'
                    required: true
                missing: required: true
        arrayOfObjects:
            type: 'array'
            required: true
            items:
                type: 'object'
                additionalProperties: false
                properties:
                    correct: type: 'boolean'
                    shouldBeBoolean: type: 'boolean'
                    missing: required: true
        arrayOfWhatShouldBeStrings:
            type: 'array'
            items: type: 'string'
