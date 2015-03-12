var r = require('ramda');
var _$ = require('./jQueryHelper');
var stripComments = require('strip-json-comments');

var JsonEditor = function (elementId) {
    var editor = document.getElementById(elementId);
    var textarea = editor.getElementsByTagName('textarea')[0];
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

	var onChange = function (listener) {
		textarea.addEventListener('input', listener);
	};
	var emitChangeEvent = function () {
		textarea.dispatchEvent(new Event('input'));
	};

	var setString = function (value) {
		textarea.value = value;
		emitChangeEvent();
	};
	var getString = function () {
		return textarea.value;
	};
	var getJson = function () {
		return parse(getString());
	};

    var highlightUnparseableJson = function () {
        _$.setCssClass($textarea, 'unparseable', isValid());
    };
	onChange(highlightUnparseableJson);

    var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
    var reformat = r.pipe(getJson, jsonToString, setString);
    var enableButton = function () {
        _$.setCssClass($(editor).find('.button'), 'enabled', !isValid());
        $(editor).find('.button').unbind('click');
        if (isValid())
            $(editor).find('.button').click(reformat);
    };
    onChange(enableButton);

	return {
		isValid: isValid,
		onChange: onChange,
		setString: setString,
		getString: getString,
		getJson: getJson
	};
};

module.exports = JsonEditor;
