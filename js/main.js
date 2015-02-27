var r = require('ramda');

var schemaContainer = document.getElementById('schema');
var jsonContainer = document.getElementById('jsonToValidate');

var JsonEditor = require('./jsonEditor');
var jsonEditor = JsonEditor('jsonToValidate');
var schemaEditor = JsonEditor('schema');

var stripComments = require('strip-json-comments');
var parse = r.pipe(stripComments, JSON.parse);

var highlighter = require('./imjv-highlighter');
var revalidate = function () {
    var schema = parse(schemaContainer.value);
    var json = parse(jsonContainer.value);
    highlighter.validateJsonAgainstSchema(json, schema);
};
var storeSchema = function () {
    localStorage.setItem('schema', schemaContainer.value);
};
var storeJson = function () {
    localStorage.setItem('json', jsonContainer.value);
};

schemaEditor.onChange(revalidate);
schemaEditor.onChange(storeSchema);
jsonEditor.onChange(revalidate);
jsonEditor.onChange(storeJson);


var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
var defaults = require('./defaults');

var loadUserContent = function (key, jsonEditor, defaultAsObject) {
    var defaultToExample = r.defaultTo(jsonToString(defaultAsObject));
	jsonEditor.setString(defaultToExample(localStorage.getItem(key)));
};

loadUserContent('schema', schemaEditor, defaults.schema);
loadUserContent('json', jsonEditor, defaults.json);
