var r = require('ramda');

var prependStr = r.useWith(r.replace(/^/), r.identity);
var appendStr = r.useWith(r.replace(/$/), r.identity);

var prependPath = r.curry(function (parentPath, subpath) {
    if (parentPath === '') return subpath;
    return r.join('.')([parentPath, subpath]);
});

var errorToPathComponents = r.pipe(
    r.prop('field'), 
    r.split('.'), 
    r.tail);
var pathComponentsToSelector = r.pipe(
    r.map(prependStr('.')), 
    r.join(' '),
    r.replace(/\*/g, 'array-element')
);
var errorsToSelectors = r.pipe(
    r.map(errorToPathComponents),
    r.map(pathComponentsToSelector),
    r.uniq
);

module.exports = {
    prependStr: prependStr,
    appendStr: appendStr,

    errorToPathComponents: errorToPathComponents,
    pathComponentsToSelector: pathComponentsToSelector,
    errorsToSelectors: errorsToSelectors,

    prependPath: prependPath
};
