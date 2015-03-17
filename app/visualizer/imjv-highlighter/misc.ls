r = require('ramda')

prependStr = r.useWith(r.replace(/^/), r.identity)
appendStr = r.useWith(r.replace(/$/), r.identity)

prependPath = (parentPath, subpath) -->
    if (parentPath === '') then return subpath
    r.join('.')([parentPath, subpath])

pathToComponents = r.split('.')
componentsToPath = r.join('.')

errorToPathComponents = r.pipe(
    r.prop('field')
    pathToComponents
    r.tail
)
errorToPath = r.pipe(
    errorToPathComponents
    componentsToPath
)
pathComponentsToSelector = r.pipe(
    r.map(prependStr('.'))
    r.join(' ')
    r.replace(/\*/g, 'array-element')
)
pathToSelector = r.pipe(
    pathToComponents
    pathComponentsToSelector
)
errorsToSelectors = r.pipe(
    r.map(errorToPathComponents)
    r.map(pathComponentsToSelector)
    r.uniq
)

module.exports = {
    prependStr
    appendStr

    errorToPathComponents
    errorToPath
    pathComponentsToSelector
    pathToSelector
    errorsToSelectors

    prependPath

    pathToComponents
    componentsToPath
}
