var r = require('ramda');
var stripComments = require('strip-json-comments');

var setClass = function ($el, cssClass, value) {
    if (value) {
        $el.removeClass(cssClass);
        return;
    }
    $el.addClass(cssClass);
};

var jsonTextarea = function (elementId) {
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

    var validateJson = function() {
        setClass($textarea, 'unparseable', isValid());
    };

    textarea.addEventListener('input', validateJson);
};

module.exports = jsonTextarea;
