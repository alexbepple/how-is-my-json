var r = require('ramda');
var _$ = require('./jQueryHelper');
var stripComments = require('strip-json-comments');

var JsonEditor = function (elementId) {
    var textarea = document.getElementById(elementId);
    var $textarea = $(textarea);

    var parse = r.pipe(stripComments, JSON.parse);
    var isValid = function () {
        try {
            parse(textarea.value);
            return true;
        } catch (e) {
            return false;
        }
    };

    var validateJson = function () {
        _$.setCssClass($textarea, 'unparseable', isValid());
    };

	var onChange = function (listener) {
		textarea.addEventListener('input', listener);
	};
	var emitChangeEvent = function () {
		textarea.dispatchEvent(new Event('input'));
	};

	var setString = function (value) {
		textarea.textContent = value;
		emitChangeEvent();
	};
	var getString = function () {
		return textarea.value;
	};
	var getJson = function () {
		return parse(getString());
	};

	onChange(validateJson);

	return {
		isValid: isValid,
		onChange: onChange,
		setString: setString,
		getString: getString,
		getJson: getJson
	};
};

module.exports = JsonEditor;
