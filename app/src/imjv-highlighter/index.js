var validator = require('is-my-json-valid');
var r = require('ramda');
var m = require('./misc');
var addPathTo = require('./missing').addPathTo;
var additional = require('./additional');

var jsonToDom = require('../jsonToDom');
var removeAllChildren = function (node) {
    while (node.firstChild) {
        node.removeChild(node.firstChild);
    }
};
var displayJson = function (json) {
    var resultContainer = document.getElementById('validationResult');
    removeAllChildren(resultContainer);
    resultContainer.appendChild(jsonToDom(json));
};

var validateJsonAgainstSchema = function (json, schema) {
    var validate = validator(schema);
    var isValid = validate(json);

    if (isValid) {
        $('.summary').hide();
        $('.summary.valid').show();
        displayJson(json);
        return;
    }

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

    displayJson(jsonWithMissingProperties);

    var addClass = function (cssClass, selectors) {
        $(r.join(',', selectors)).addClass(cssClass);
    };

    $('.summary').hide();
    $('.summary.invalid').show();
    $('#countWrongType').text('' + selectorsWrongType.length);
    addClass('validation-wrong-type', selectorsWrongType);

    $('#countMissing').text('' + selectorsMissing.length);
    addClass('validation-missing', selectorsMissing);

    var selectorsAdditional = additional
        .selectorsForAdditionalProperties(schema, json, validate.errors);
    $('#countAdditional').text('' + selectorsAdditional.length);
    addClass('validation-additional', selectorsAdditional);
};

module.exports = {
    validateJsonAgainstSchema: validateJsonAgainstSchema
};
