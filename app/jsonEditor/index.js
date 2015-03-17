var r = require('ramda');
var stripComments = require('strip-json-comments');

var JsonEditor = function (elementId) {
    var editor = document.getElementById(elementId);
    var textarea = editor.getElementsByTagName('textarea')[0];
    var $textarea = $(textarea);

    var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
    var parse = r.pipe(stripComments, JSON.parse);
    var isValid = function () {
        try {
            getJson();
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

	var _setString = function (value) {
		textarea.value = value;
	};
	var getString = function () {
		return textarea.value;
	};
	var setString = function (value) {
		_setString(value);
		emitChangeEvent();
	};
	var getJson = function () {
		return parse(getString());
	};
    var setJson = function (json) {
        setString(jsonToString(json));
    };

    var highlightUnparseableJson = function () {
        $textarea.toggleClass('unparseable', !isValid());
    };
	onChange(highlightUnparseableJson);

    var reformat = r.pipe(getJson, jsonToString, setString);
    var reformatButton = $(editor).find('.button');
    var enableReformatButton = function () {
        reformatButton.toggleClass('enabled', isValid());
        reformatButton.unbind('click');
        if (isValid()) reformatButton.bind('click', reformat);
    };
    onChange(enableReformatButton);

	return {
		isValid: isValid,
		onChange: onChange,
		setString: setString,
		getString: getString,
		getJson: getJson,
        setJson: setJson
	};
};

module.exports = JsonEditor;
