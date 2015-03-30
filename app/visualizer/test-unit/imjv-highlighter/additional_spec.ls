require! {
    'visualizer/imjv-highlighter/additional':h
    ramda:r
    {assertThat, equalTo, hasSize}: hamjest
}

describe 'Highlighter' ->
    specify 'converts additional-properties errors into CSS selectors' ->
        relevantSchemaExcerpt = properties: {a: {properties: {}}}
        json = a: {a: 1}
        imjvErrors = [ { field: 'data.a', message: 'has additional properties' } ]
        assertThat h.selectors(relevantSchemaExcerpt, json, imjvErrors),
            equalTo ['.a .a']

    specify 'only returns unique selectors' ->
        relevantSchemaExcerpt = properties: {}
        json = a: null
        imjvErrors =
            * field: 'data', message: 'has additional properties'
            * field: 'data', message: 'has additional properties'
        assertThat h.selectors(relevantSchemaExcerpt, json, imjvErrors),
            hasSize 1

    describe 'lists properties' ->
        specify 'at top level' ->
            assertThat h.propertiesInObject(a:  null, ''), equalTo ['a']
        specify 'at 2nd level' ->
            assertThat h.propertiesInObject(a: b: null, 'a'), equalTo ['b']
        specify 'in arrays' ->
            assertThat h.propertiesInObject([{a: null}], '*'), equalTo ['a']
        specify 'in nested arrays' ->
            assertThat h.propertiesInObject([[{a: null}]], '*.*'), equalTo ['a']

    describe 'converts object paths to schema paths' ->
        specify 'root path' ->
            assertThat h.objectPathToSchemaPath(''), equalTo 'properties'
        specify 'top-level path' ->
            assertThat h.objectPathToSchemaPath('a'),
                equalTo 'properties.a.properties'
        specify 'path with array' ->
            assertThat h.objectPathToSchemaPath('*'),
                equalTo 'items.properties'
        specify 'path with multiple arrays' ->
            assertThat h.objectPathToSchemaPath('*.*'),
                equalTo 'items.items.properties'

    describe '#pathsOfAdditionalProperties' ->
        specify 'prepends parent path to difference of actual and defined' ->
            actual = r.always ['b', 'c']
            defined = r.always ['b']
            assertThat h.pathsOfAdditionalProperties(actual, defined, 'a'),
                equalTo ['a.c']

