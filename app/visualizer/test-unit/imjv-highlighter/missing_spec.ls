require! {
	'visualizer/imjv-highlighter/missing':h
	ramda:r
	{assertThat, everyItem, hasProperty, defined}: hamjest
}

describe 'Highlighter injects paths' ->
	specify 'flat path into object' ->
		assertThat h.addPathTo({}, 'a'), hasProperty 'a'
	specify 'deep path into object' ->
		assertThat h.addPathTo({}, 'a.b'), hasProperty('a', hasProperty 'b')
	specify 'flat path into objects in array' ->
		assertThat h.addPathTo([{},{}], '*.a'), everyItem hasProperty 'a'
	specify 'deep path into objects in array' ->
		assertThat h.addPathTo([{},{}], '*.a.a'), everyItem(
			hasProperty 'a', hasProperty 'a')
	specify 'path into array under flat path' ->
		assertThat h.addPathTo({a: [{},{}]}, 'a.*.a'),
			hasProperty 'a', everyItem( hasProperty 'a')
	specify 'path into array under deep path' ->
		assertThat h.addPathTo({a: {a: [{},{}]}}, 'a.a.*.a'),
			hasProperty 'a', hasProperty 'a', everyItem(hasProperty 'a')
	specify 'path into array within an array' ->
		assertThat h.addPathTo({a: [{a: [{}]}]}, 'a.*.a.*.a'),
			hasProperty 'a', everyItem(
				hasProperty 'a', everyItem(
					hasProperty 'a'))
