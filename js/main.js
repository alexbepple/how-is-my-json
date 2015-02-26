var r = require('ramda');

var schemaContainer = document.getElementById('schema');
var jsonContainer = document.getElementById('jsonToValidate');

var JsonTextarea = require('./jsonTextarea');
JsonTextarea('jsonToValidate');
JsonTextarea('schema');

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

schemaContainer.addEventListener('input', revalidate);
schemaContainer.addEventListener('input', storeSchema);
jsonContainer.addEventListener('input', revalidate);
jsonContainer.addEventListener('input', storeJson);


var jsonToString = function (json) { return JSON.stringify(json, null, 4); };
var defaults = require('./defaults');

var loadUserContent = function (key, container, defaultAsObject) {
    var defaultToExample = r.defaultTo(jsonToString(defaultAsObject));
    container.textContent = defaultToExample(localStorage.getItem(key));
    container.dispatchEvent(new Event('input'));
};

loadUserContent('schema', schemaContainer, defaults.schema);
loadUserContent('json', jsonContainer, defaults.json);
