
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
        $('.summary.invalid').show()

        $('.summary.invalid li .separator').hide()

        if wrong == 0
            $('.summary.invalid .validation-wrong-type').hide()
        else
            $('.summary.invalid .validation-wrong-type').show()
        setNumberValue('#countWrongType', wrong)

        if missing == 0
            $('.summary.invalid .validation-missing').hide()
        else
            $('.summary.invalid .validation-missing').show()
        setNumberValue('#countMissing', missing)

        if additional == 0
            $('.summary.invalid .validation-additional').hide()
        else
            $('.summary.invalid .validation-additional').show()
        setNumberValue('#countAdditional', additional)

        $('.summary.invalid li:visible').slice(1).find('.separator').show()

module.exports =
    Summary
