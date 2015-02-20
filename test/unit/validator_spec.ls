require! {
	validator:v
	{assertThat, everyItem, hasProperty, defined}: hamjest
}

describe 'Validator#addPath' ->
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

