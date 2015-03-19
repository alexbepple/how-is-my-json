require! {
    hamjest: {assertThat, equalTo}
    'schema/schemaEnhancer': {prohibitAdditionalProperties}
}

describe 'Schema enhancer #prohibitAdditionalProperties' ->

    specify 'prohibits additional properties for objects' ->
        assertThat prohibitAdditionalProperties(type:'object'),
            equalTo type:'object', additionalProperties:false

    specify 'does not prohibit additional properties otherwise' ->
        assertThat prohibitAdditionalProperties({}), equalTo {}

    specify 'does not prohibit when additional properties explicitly allowed' ->
        explicitlyAllowed =
            type:'object'
            additionalProperties:true
        assertThat prohibitAdditionalProperties(explicitlyAllowed),
            equalTo explicitlyAllowed

    specify 'does not modify original object' ->
        foo = type:'object'
        prohibitAdditionalProperties foo
        assertThat foo, equalTo type:'object'

    specify 'traverses the object tree' ->
        assertThat prohibitAdditionalProperties(foo: type:'object'),
            equalTo foo: type:'object', additionalProperties:false
