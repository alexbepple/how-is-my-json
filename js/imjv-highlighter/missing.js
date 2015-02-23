var r = require('ramda');

var dropLastChar = r.pipe(r.split(''), r.init, r.join(''));
var addPathTo = function (object, path) {
    var pathSegments = r.split('*.', path);

    if (r.length(pathSegments) === 1)
        return r.assocPath(path, '…', object);

    var pathInArrayElement = r.pipe(r.tail, r.join('*.'))(pathSegments);
    if (Array.isArray(object)) {
        return r.map(addPath(pathInArrayElement))(object);
    }

    var pathToArray = r.pipe(r.head, dropLastChar)(pathSegments);
    var pathFromArrayOn = '*.' + pathInArrayElement;
    var augmentedArray = addPathTo(r.path(pathToArray, object), pathFromArrayOn);
    return r.assocPath(pathToArray, augmentedArray, object);
};
var addPath = r.flip(addPathTo);

module.exports = {
    addPathTo: addPathTo
};
