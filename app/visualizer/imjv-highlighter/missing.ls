r = require('ramda')

dropLastChar = r.pipe(r.split(''), r.init, r.join(''))
addPathTo = (object, path) ->
    pathSegments = r.split('*.', path)

    if r.length(pathSegments) === 1
        return r.assocPath(path, '…', object)

    pathInArrayElement = r.pipe(r.tail, r.join('*.'))(pathSegments)
    if Array.isArray(object)
        return r.map(addPath(pathInArrayElement))(object)

    pathToArray = r.pipe(r.head, dropLastChar)(pathSegments)
    pathFromArrayOn = '*.' + pathInArrayElement
    augmentedArray = addPathTo(r.path(pathToArray, object), pathFromArrayOn)
    r.assocPath(pathToArray, augmentedArray, object)

addPath = r.flip addPathTo

module.exports = {
    addPathTo
}
