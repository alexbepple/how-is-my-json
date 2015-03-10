var r = require('ramda');

var prependStr = r.useWith(r.replace(/^/), r.identity);
var appendStr = r.useWith(r.replace(/$/), r.identity);

var prependPath = r.curry(function (parentPath, subpath) {
    if (parentPath === '') return subpath;
    return r.join('.')([parentPath, subpath]);
});

var pathToComponents = r.split('.');
var componentsToPath = r.join('.');

var errorToPathComponents = r.pipe(
    r.prop('field'),
    pathToComponents,
    r.tail
);
var errorToPath = r.pipe(
    errorToPathComponents,
    componentsToPath
);
var pathComponentsToSelector = r.pipe(
    r.map(prependStr('.')),
    r.join(' '),
    r.replace(/\*/g, 'array-element')
);
var pathToSelector = r.pipe(
    pathToComponents,
    pathComponentsToSelector
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
    errorToPath: errorToPath,
    pathComponentsToSelector: pathComponentsToSelector,
    pathToSelector: pathToSelector,
    errorsToSelectors: errorsToSelectors,

    prependPath: prependPath,

    pathToComponents: pathToComponents,
    componentsToPath: componentsToPath
};
