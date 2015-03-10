
Summary = ->
    clearSummary = -> $('.summary').hide()
    setNumberValue = (selector, value) -> $(selector).text('' + value);

    showUnmetPreconditions: ->
        clearSummary()
        $('.summary.unmet-preconditions').show()
    showValid: ->
        clearSummary()
        $('.summary.valid').show()
    showInvalid: ({wrong, missing, additional}) ->
        clearSummary()
        $('.summary.invalid').show();
        setNumberValue('#countWrongType', wrong);
        setNumberValue('#countMissing', missing);
        setNumberValue('#countAdditional', additional);

module.exports =
    Summary
