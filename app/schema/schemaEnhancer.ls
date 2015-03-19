require! {
    ramda: r
}

prohibitAdditionalPropertiesShallow = ->
    if it.type == 'object' and not it.additionalProperties
        it.additionalProperties = false

traverse = (node, {eachObject}) ->
    if typeof node == 'object'
        eachObject node
        for k, v of node
            traverse v, {eachObject}

prohibitAdditionalProperties = (schema) ->
    newSchema = r.clone schema
    traverse newSchema, eachObject:prohibitAdditionalPropertiesShallow
    return newSchema

module.exports = {
    prohibitAdditionalProperties
}
