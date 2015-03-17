var crel = require('crel');
var util = require('util');
var r = require('ramda');

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

var arrayToDom = function (array) {
	var arrayElementToDom = function (el) {
		return crel('span', {class: 'array-element'},
			jsonToDom(el)
		);
	};
	var values = r.map(arrayElementToDom)(r.values(array));
	return crel('span', {class: 'value type-array'}, values);
};

var nullToDom = function (value) {
    return crel('span', {class: 'value null'}, 'null');
};

var genericTransformer = function (type) {
    return function (value) {
        return crel('span', {class: util.format('value type-%s', type)}, value);
    };
};

var transformers = {
	string: genericTransformer('string'),
    boolean: genericTransformer('boolean'),
    number: genericTransformer('number'),
	object: objectToDom
};

var transformerFor = function (json) {
    if (json === undefined) throw "'undefined' not allowed in JSON";
    if (json === null) return nullToDom;
    if (Array.isArray(json)) return arrayToDom;
	return transformers[typeof json];
};

var jsonToDom = function (json) {
	return transformerFor(json)(json);
};

module.exports = jsonToDom;
