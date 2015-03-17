require! {
    'visualizer/imjv-highlighter/misc':h
    ramda:r
    {assertThat, equalTo}: hamjest
}

describe 'Highlighter' ->
    describe 'prepends paths' ->
        specify 'root path' ->
            assertThat h.prependPath('', 'a'), equalTo ('a')
        specify 'top-level path' ->
            assertThat h.prependPath('a', 'b'), equalTo ('a.b')
