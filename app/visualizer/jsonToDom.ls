crel = require('crel')
util = require('util')
r = require('ramda')

objectToDom = (object) ->
    keyToDom = (key) ->
        crel('span', {class: util.format('key-value-pair %s', key)},
            crel('span', {class:'key'}, key),
            jsonToDom(object[key])
        )
    props = r.map(keyToDom)(r.keys(object))
    return crel('span', {class: 'value type-object'}, props)

arrayToDom = (array) ->
    arrayElementToDom = -> crel 'span', {class: 'array-element'}, jsonToDom(it)
    values = r.map(arrayElementToDom)(r.values(array))
    return crel('span', {class: 'value type-array'}, values)

nullToDom = -> crel('span', {class: 'value null'}, 'null')

genericTransformer = (type) ->
    (value) -> crel('span', {class: util.format('value type-%s', type)}, value)

transformers = {
    string: genericTransformer('string'),
    boolean: genericTransformer('boolean'),
    number: genericTransformer('number'),
    object: objectToDom
}

transformerFor = (json) ->
    if (json === undefined) then throw "'undefined' not allowed in JSON"
    if (json === null) then return nullToDom
    if (Array.isArray(json)) then return arrayToDom
    return transformers[typeof json]

jsonToDom = -> transformerFor(it)(it)

module.exports = jsonToDom
