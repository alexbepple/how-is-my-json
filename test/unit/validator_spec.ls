require! {
	validator:v
	{assertThat, hasProperty, defined}: hamjest
}

describe 'Validator#addPath' ->
	specify 'injects flat paths into objects' ->
		assertThat v.addPath({}, 'a'), hasProperty 'a'
	specify 'injects deep paths into objects' ->
		assertThat v.addPath({}, 'a.b'), hasProperty('a', hasProperty 'b')

