var validator = require('is-my-json-valid');
var r = require('ramda');
var m = require('./misc');
var addPathTo = require('./missing').addPathTo;
var additional = require('./additional');

var validateJsonAgainstSchema = function (json, schema) {
    var validate = validator(schema);
    validate(json);

    var isWrongType = r.propEq('message', 'is the wrong type');
    var selectorsWrongType = r.pipe(
        r.filter(isWrongType),
        m.errorsToSelectors
    )(validate.errors);

    var isMissing = r.propEq('message', 'is required');
    var selectorsMissing = r.pipe(
        r.filter(isMissing),
        m.errorsToSelectors
    )(validate.errors);

    var jsonWithMissingProperties = r.pipe(
        r.filter(isMissing),
        r.map(m.errorToPathComponents),
        r.map(r.join('.')), 
        r.reduce(addPathTo, json)
    )(validate.errors);

    var jsonToDom = require('../jsonToDom');
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
             additional.selectorsForAdditionalProperties(schema, json, validate.errors));
};

module.exports = {
    validateJsonAgainstSchema: validateJsonAgainstSchema
};
