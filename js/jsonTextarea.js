var r = require('ramda');
var stripComments = require('strip-json-comments');

var setClass = function ($el, cssClass, value) {
    if (value) {
        $el.removeClass(cssClass);
        return;
    }
    $el.addClass(cssClass);
};

var JsonTextarea = function (elementId) {
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
        setClass($textarea, 'unparseable', isValid());
    };

	var onChange = function (listener) {
		textarea.addEventListener('input', listener);
	};
	var emitChangeEvent = function () {
		textarea.dispatchEvent(new Event('input'));
	};

	var setValue = function (value) {
		textarea.textContent = value;
		emitChangeEvent();
	};

	onChange(validateJson);

	return {
		onChange: onChange,
		setValue: setValue
	};
};

module.exports = JsonTextarea;
