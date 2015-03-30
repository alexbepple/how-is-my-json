require! {
    ramda: r
    'is-my-json-valid': validator
    '../jsonEditor/_.ls': JsonEditor
    '../schema/schemaEnhancer.ls': schemaEnhancer
}

SchemaEditor = (elementId) ->
    that = JsonEditor elementId

    that.isSchemaValid = ->
        try
            validator that.getJson()
            return true
        catch
            return false

    that.isJsonValid = that.isValid
    that.isValid = -> that.isJsonValid() && that.isSchemaValid()

    that.onClick 'prohibitAdditionalProps', r.pipe(
        that.getJson
        schemaEnhancer.prohibitAdditionalProperties
        that.setJson
    )

    that

module.exports = SchemaEditor
