var crel = require('crel');
var util = require('util');
var r = require('ramda');

var stringToDom = function (string) {
	return crel('span', {class: 'value type-string'}, string);
};

var objectToDom = function (object) {
	var keyToDom = function (key) {
		return crel('span', {class: util.format('key-value-pair %s', key)},
			crel('span', {class:'key'}, key),
			jsonToDom(object[key])
		);
	};
	var props = r.map(keyToDom)(r.keys(object));
	return crel('span', {class: 'value type-object'}, props);
};

var transformers = {
	string: stringToDom,
	object: objectToDom
};
var jsonToDom = function (json) {
	var transformer = transformers[typeof json];
	return transformer(json);
};

module.exports = jsonToDom;
