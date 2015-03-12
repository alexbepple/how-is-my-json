var r = require('ramda');

var JsonEditor = require('./jsonEditor');
var jsonEditor = JsonEditor('json');
var schemaEditor = JsonEditor('schema');

var summary = require('./summary.ls')();

var highlighter = require('./imjv-highlighter');
var revalidate = function () {
    var bothInputsValid = jsonEditor.isValid() && schemaEditor.isValid();
    if (bothInputsValid) {
        var json = jsonEditor.getJson();
        var schema = schemaEditor.getJson();
        highlighter.validateJsonAgainstSchema(json, schema, summary);
    } else {
        summary.showUnmetPreconditions();
    }
	$('#validationResult').toggleClass('greyed-out', !bothInputsValid);
};

jsonEditor.onChange(revalidate);
schemaEditor.onChange(revalidate);


var storeJson = function () {
	localStorage.setItem('json', jsonEditor.getString());
};
var storeSchema = function () {
	localStorage.setItem('schema', schemaEditor.getString());
};

var defaults = require('./defaults.ls');
var loadUserContent = function (key, jsonEditor, defaultAsObject) {
    var storedValue = localStorage.getItem(key);
    if (storedValue)
        jsonEditor.setString(storedValue);
    else
        jsonEditor.setJson(defaultAsObject);
};

loadUserContent('json', jsonEditor, defaults.json);
loadUserContent('schema', schemaEditor, defaults.schema);
jsonEditor.onChange(storeJson);
schemaEditor.onChange(storeSchema);
