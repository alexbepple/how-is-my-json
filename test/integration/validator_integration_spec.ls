require! {
	validator:v
	{assertThat, equalTo}: hamjest
}

describe 'Validator#selectorsForAdditionalProperties' ->
	specify 'converts is-my-json-valid errors into CSS selectors' ->
		relevantSchemaExcerpt = properties: {a: {properties: {}}}
		json = a: {a: 1}
		imjvErrors = [ { field: 'data.a', message: 'has additional properties' } ]
		assertThat v.selectorsForAdditionalProperties(
			relevantSchemaExcerpt, json, imjvErrors
		), equalTo ['.a .a']


