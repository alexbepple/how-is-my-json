require! {
	validator:v
	{assertThat, everyItem, hasProperty, defined, equalTo}: hamjest
}

describe 'Validator#addPathTo' ->
	specify 'injects flat path into object' ->
		assertThat v.addPathTo({}, 'a'), hasProperty 'a'
	specify 'injects deep path into object' ->
		assertThat v.addPathTo({}, 'a.b'), hasProperty('a', hasProperty 'b')
	specify 'injects flat path into objects in array' ->
		assertThat v.addPathTo([{},{}], '*.a'), everyItem hasProperty 'a'
	specify 'injects deep path into objects in array' ->
		assertThat v.addPathTo([{},{}], '*.a.a'), everyItem(
			hasProperty 'a', hasProperty 'a')
	specify 'injects path into array under flat path' ->
		assertThat v.addPathTo({a: [{},{}]}, 'a.*.a'),
			hasProperty 'a', everyItem( hasProperty 'a')
	specify 'injects path into array under deep path' ->
		assertThat v.addPathTo({a: {a: [{},{}]}}, 'a.a.*.a'),
			hasProperty 'a', hasProperty 'a', everyItem(hasProperty 'a')
	specify 'injects path into array within an array' ->
		assertThat v.addPathTo({a: [{a: [{}]}]}, 'a.*.a.*.a'),
			hasProperty 'a', everyItem(
				hasProperty 'a', everyItem(
					hasProperty 'a'))

describe 'Validator#propertiesInObject' ->
	specify 'lists properties at top level' ->
		assertThat v.propertiesInObject(a:  null, ''), equalTo ['a']
	specify 'lists properties at 2nd level' ->
		assertThat v.propertiesInObject(a: b: null, 'a'), equalTo ['b']
	specify 'lists properties in arrays' ->
		assertThat v.propertiesInObject([{a: null}], '*'), equalTo ['a']
	specify 'lists properties in nested arrays' ->
		assertThat v.propertiesInObject([[{a: null}]], '*.*'), equalTo ['a']

describe 'Validator#objectPathToSchemaPath' ->
	specify 'converts root path' ->
		assertThat v.objectPathToSchemaPath(''), equalTo 'properties'
	specify 'converts top-level path' ->
		assertThat v.objectPathToSchemaPath('a'),
			equalTo 'properties.a.properties'
	specify 'converts path with array' ->
		assertThat v.objectPathToSchemaPath('*'),
			equalTo 'items.properties'
	specify 'converts path with multiple arrays' ->
		assertThat v.objectPathToSchemaPath('*.*'),
			equalTo 'items.items.properties'

