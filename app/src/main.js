var r = require('ramda');
var _$ = require('./jQueryHelper');

var JsonEditor = require('./jsonEditor');
var jsonEditor = JsonEditor('jsonToValidate');
var schemaEditor = JsonEditor('schema');

var highlighter = require('./imjv-highlighter');
var revalidate = function () {
    var bothInputsValid = jsonEditor.isValid() && schemaEditor.isValid();
    if (bothInputsValid) {
        var json = jsonEditor.getJson();
        var schema = schemaEditor.getJson();
        highlighter.validateJsonAgainstSchema(json, schema);
    }
	_$.setCssClass($('#validationResult'), 'greyed-out', bothInputsValid);
};

jsonEditor.onChange(revalidate);
schemaEditor.onChange(revalidate);


var storeJson = function () {
	localStorage.setItem('json', jsonEditor.getString());
};
var storeSchema = function () {
	localStorage.setItem('schema', schemaEditor.getString());
};

var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
var defaults = require('./defaults.ls');

var loadUserContent = function (key, jsonEditor, defaultAsObject) {
	var defaultToExample = r.defaultTo(jsonToString(defaultAsObject));
	jsonEditor.setString(defaultToExample(localStorage.getItem(key)));
};

loadUserContent('json', jsonEditor, defaults.json);
loadUserContent('schema', schemaEditor, defaults.schema);
jsonEditor.onChange(storeJson);
schemaEditor.onChange(storeSchema);
