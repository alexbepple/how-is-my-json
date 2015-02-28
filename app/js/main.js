var r = require('ramda');
var _$ = require('./jQueryHelper');

var JsonEditor = require('./jsonEditor');
var jsonEditor = JsonEditor('jsonToValidate');
var schemaEditor = JsonEditor('schema');

var highlighter = require('./imjv-highlighter');
var revalidate = function () {
	var json = jsonEditor.getJson();
	var schema = schemaEditor.getJson();
	highlighter.validateJsonAgainstSchema(json, schema);
};

var greyOutValidationResultIfRequirementsUnmet = function () {
	_$.setCssClass($('#validationResult'), 'greyed-out', 
				jsonEditor.isValid() && schemaEditor.isValid()
    );
};

jsonEditor.onChange(greyOutValidationResultIfRequirementsUnmet);
schemaEditor.onChange(greyOutValidationResultIfRequirementsUnmet);
jsonEditor.onChange(revalidate);
schemaEditor.onChange(revalidate);


var storeJson = function () {
	localStorage.setItem('json', jsonEditor.getString());
};
var storeSchema = function () {
	localStorage.setItem('schema', schemaEditor.getString());
};

var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
var defaults = require('./defaults');

var loadUserContent = function (key, jsonEditor, defaultAsObject) {
	var defaultToExample = r.defaultTo(jsonToString(defaultAsObject));
	jsonEditor.setString(defaultToExample(localStorage.getItem(key)));
};

loadUserContent('json', jsonEditor, defaults.json);
loadUserContent('schema', schemaEditor, defaults.schema);
jsonEditor.onChange(storeJson);
schemaEditor.onChange(storeSchema);
