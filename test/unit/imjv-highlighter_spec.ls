require! {
	'imjv-highlighter':h
	ramda:r
	{assertThat, everyItem, hasProperty, defined, equalTo}: hamjest
}

describe 'Highlighter #addPathTo' ->
	specify 'injects flat path into object' ->
		assertThat h.addPathTo({}, 'a'), hasProperty 'a'
	specify 'injects deep path into object' ->
		assertThat h.addPathTo({}, 'a.b'), hasProperty('a', hasProperty 'b')
	specify 'injects flat path into objects in array' ->
		assertThat h.addPathTo([{},{}], '*.a'), everyItem hasProperty 'a'
	specify 'injects deep path into objects in array' ->
		assertThat h.addPathTo([{},{}], '*.a.a'), everyItem(
			hasProperty 'a', hasProperty 'a')
	specify 'injects path into array under flat path' ->
		assertThat h.addPathTo({a: [{},{}]}, 'a.*.a'),
			hasProperty 'a', everyItem( hasProperty 'a')
	specify 'injects path into array under deep path' ->
		assertThat h.addPathTo({a: {a: [{},{}]}}, 'a.a.*.a'),
			hasProperty 'a', hasProperty 'a', everyItem(hasProperty 'a')
	specify 'injects path into array within an array' ->
		assertThat h.addPathTo({a: [{a: [{}]}]}, 'a.*.a.*.a'),
			hasProperty 'a', everyItem(
				hasProperty 'a', everyItem(
					hasProperty 'a'))

describe 'Highlighter #propertiesInObject' ->
	specify 'lists properties at top level' ->
		assertThat h.propertiesInObject(a:  null, ''), equalTo ['a']
	specify 'lists properties at 2nd level' ->
		assertThat h.propertiesInObject(a: b: null, 'a'), equalTo ['b']
	specify 'lists properties in arrays' ->
		assertThat h.propertiesInObject([{a: null}], '*'), equalTo ['a']
	specify 'lists properties in nested arrays' ->
		assertThat h.propertiesInObject([[{a: null}]], '*.*'), equalTo ['a']

describe 'Highlighter #objectPathToSchemaPath' ->
	specify 'converts root path' ->
		assertThat h.objectPathToSchemaPath(''), equalTo 'properties'
	specify 'converts top-level path' ->
		assertThat h.objectPathToSchemaPath('a'),
			equalTo 'properties.a.properties'
	specify 'converts path with array' ->
		assertThat h.objectPathToSchemaPath('*'),
			equalTo 'items.properties'
	specify 'converts path with multiple arrays' ->
		assertThat h.objectPathToSchemaPath('*.*'),
			equalTo 'items.items.properties'

describe 'Highlighter #prependPath' ->
	specify 'appends path to root path' ->
		assertThat h.prependPath('', 'a'), equalTo ('a')
	specify 'appends path to top-level path' ->
		assertThat h.prependPath('a', 'b'), equalTo ('a.b')

describe 'Highlighter #pathsOfAdditionalProperties' ->
	specify 'prepends parent path to difference of actual and defined' ->
		actual = r.always ['b', 'c']
		defined = r.always ['b']
		assertThat h.pathsOfAdditionalProperties(actual, defined, 'a'),
			equalTo ['a.c']

