var r = require('ramda');

var schemaContainer = document.getElementById('schema');
var jsonContainer = document.getElementById('jsonToValidate');

var JsonTextarea = require('./jsonTextarea');
var jsonTextarea = JsonTextarea('jsonToValidate');
var schemaTextarea = JsonTextarea('schema');

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

schemaTextarea.onChange(revalidate);
schemaTextarea.onChange(storeSchema);
jsonTextarea.onChange(revalidate);
jsonTextarea.onChange(storeJson);


var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
var defaults = require('./defaults');

var loadUserContent = function (key, jsonEditor, defaultAsObject) {
    var defaultToExample = r.defaultTo(jsonToString(defaultAsObject));
	jsonEditor.setValue(defaultToExample(localStorage.getItem(key)));
};

loadUserContent('schema', schemaTextarea, defaults.schema);
loadUserContent('json', jsonTextarea, defaults.json);
