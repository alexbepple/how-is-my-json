require! {
    ramda: r
    './misc.ls': m
}

selectors = (errors) ->
    isWrongType = r.propEq 'message', 'is the wrong type'
    selectorsWrongType = r.pipe(
        r.filter(isWrongType)
        m.errorsToSelectors
    )(errors)

module.exports = {
    selectors
}
